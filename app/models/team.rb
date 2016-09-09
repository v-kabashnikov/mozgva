class Team < ApplicationRecord
  MAX_MEMBERS_COUNT = 9

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
    members_count + invitations_count >= MAX_MEMBERS_COUNT
  end

  def captain
    members.where(team_role: 'captain').first.try(:user)
  end

  def staff
    members.where.not(team_role: nil)
  end

  def places
    MAX_MEMBERS_COUNT - members_count - invitations_count
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
    Invitation.where(user: user).where.not(team: self).update_all(status: 'declined')
    Member.create(user: user, team: self)
  end

  def self.pick_up_team_ratings game_team_ratings
    Rails.cache.fetch("pick_up_team_ratings", expires_in: 1.hours) do
    res = []
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
        res << {name: team.name, scores: sum_scores, percent: average_percent, games: sum_games, id: team.id}
      end
    end
    res
  end
  end
  
  private

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
