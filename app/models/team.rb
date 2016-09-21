class Team < ApplicationRecord
  MAX_MEMBERS_COUNT = 9
  MIN_TOP_SCORE = 200
  MIN_RATING_SCORE = 100

  belongs_to :league, optional: true
  has_many :members, dependent: :destroy
  has_many :users, through: :members
  has_many :invitations, dependent: :destroy
  has_many :waiting_invitations, ->{ waiting }, class_name: 'Invitation'
  has_many :invited_users, through: :waiting_invitations, class_name: "User", source: :user
  has_many :game_registrations, dependent: :destroy
  has_many :games, through: :game_registrations
  has_many :team_ratings, dependent: :destroy
  has_many :achievments, dependent: :destroy

  before_create :set_invite

  validates :name, presence: true, uniqueness: true

  rails_admin do
    edit do
      exclude_fields :team_ratings
    end
  end

  def full?
    # members_count + invitations_count >= MAX_MEMBERS_COUNT
    members_count >= MAX_MEMBERS_COUNT
  end

  def captain
    members.where(team_role: 'captain').first.try(:user)
  end

  def staff
    members.where.not(team_role: nil)
  end

  def places
    # MAX_MEMBERS_COUNT - members_count - invitations_count
    MAX_MEMBERS_COUNT - members_count
  end

  def generate_invite
    values = ('a'..'z').to_a + ('A'..'Z').to_a + (0..9).to_a
    (1..5).map{ values.sample.to_s }.join
  end

  def members_count
    members.count
  end

  def invitations_count
    invitations.count
  end

  def add_member_checking user
    # Invitation.where(user: user).where.not(team: self).update_all(status: 'declined')
    Member.create(user: user, team: self)
  end

  def self.with_scores_and_percent min_score = MIN_RATING_SCORE
    query = <<-SQL
      WITH 
        existing_scope AS (#{existing_scope_sql}),
        team_ratings_sum (id, team_id, game_id, SUM, max_score) AS
        (SELECT team_ratings.id,
                team_ratings.team_id,
                team_ratings.game_id,
                team_ratings.round_one+team_ratings.round_two+team_ratings.round_three+team_ratings.round_four+team_ratings.round_five+team_ratings.round_six+team_ratings.round_seven,
                team_ratings.max_score
         FROM team_ratings),
           games_scores (id) AS
        (SELECT games.id
         FROM games
         INNER JOIN team_ratings_sum ON team_ratings_sum.game_id=games.id
         GROUP BY games.id),
           team_rating_percents (id, team_id, game_id, SUM, percent) AS
        (SELECT team_ratings_sum.id,
                team_ratings_sum.team_id,
                team_ratings_sum.game_id,
                team_ratings_sum.sum, (team_ratings_sum.sum::float/nullif(team_ratings_sum.max_score, 0)*100)
         FROM team_ratings_sum
         INNER JOIN games_scores ON games_scores.id=team_ratings_sum.game_id)
      SELECT teams.*,
             sum(team_rating_percents.sum) AS scores,
             avg(team_rating_percents.percent) AS percent,
             count(team_rating_percents.id) AS games_count
      FROM teams
      LEFT JOIN team_rating_percents ON teams.id=team_rating_percents.team_id
      INNER JOIN existing_scope ON existing_scope.id = teams.id
      GROUP BY teams.id
      #{"HAVING sum(team_rating_percents.sum) >= :min_score" if min_score}
      ORDER BY avg(team_rating_percents.percent) DESC NULLS LAST
    SQL
    find_by_sql([query, { min_score: min_score }])
  end

  def with_scores_and_percent
    Team.where(id: id).with_scores_and_percent(nil).first
  end

  def rating_position rating
    res = rating || Team.sql_pick_up_team_ratings
    pos_in_top = res.first.find_index{ |t| t.id == id }
    pos_in_pret = res.second.find_index{ |t| t.id == id }
    position = pos_in_top + 1 if pos_in_top
    position ||= res.first.count + pos_in_pret + 1 if pos_in_pret
    position
  end

  def self.sql_pick_up_team_ratings
    res = with_scores_and_percent
    return res.select{ |t| t.scores >= MIN_TOP_SCORE }, res.select{ |t| t.scores < MIN_TOP_SCORE && t.scores >= MIN_RATING_SCORE }
  end

  def self.pick_up_team_ratings game_team_ratings
    Rails.cache.fetch("pick_up_team_ratings", expires_in: 1.hours) do
      top = []
      pretendents = []
      all.each do |team|
        sum_scores = 0
        sum_percent = 0.0
        sum_games = 0
        game_team_ratings.each do |game_tr|
          team_result = game_tr.find{|i| i[:name] == team.name}
          if team_result.present?
            sum_scores += team_result[:scores]
            sum_percent += team_result[:percent]
            sum_games += 1
          end
        end
        if sum_games > 0
          average_percent = sum_percent / sum_games.to_f
          average_percent = 0.0 if average_percent.nan?
          if sum_scores >= 200.0
            top << {name: team.name, scores: sum_scores.to_i, percent: average_percent, games_count: sum_games, id: team.id}
          elsif sum_scores >= 100.0
            pretendents << {name: team.name, scores: sum_scores.to_i, percent: average_percent, games_count: sum_games, id: team.id}
          end
        end
      end
      return top, pretendents
    end
  end
  
  private

  def self.existing_scope_sql
      # have to do this to get the binds interpolated. remove any ordering and just grab the ID
      self.connection.unprepared_statement { self.reorder(nil).select("id").to_sql }
   end

  def set_invite
    self.invite = loop do
      inv = generate_invite
      break inv unless Team.find_by_invite inv
    end
  end

  # def set_avatar
  #   self.avatar = loop do
  # end    
end
