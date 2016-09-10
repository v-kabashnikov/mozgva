class Game < ApplicationRecord
  belongs_to :place
  belongs_to :league
  has_one :city, through: :place
  has_many :photos
  has_many :game_registrations, dependent: :destroy
  has_many :teams, through: :game_registrations, 
            before_remove: :destroy_team_rating, 
            after_add: :create_team_rating
  has_many :members, through: :teams
  has_many :team_ratings, dependent: :destroy

  accepts_nested_attributes_for :photos, :allow_destroy => true
  accepts_nested_attributes_for :team_ratings, allow_destroy: true


  enum status: { 'checking' => 'checking', 'open' => 'open', 'canceled' => 'canceled', 'ended' => 'ended' }

  scope :main, ->{ where main: true }

  #validates_presence_of :max_people_number, :max_teams_number

  def status_enum
    self.class.statuses.to_a
  end

  def self.upcoming_games city = nil
  	games = open.where('games.when > ?', Time.now).order(when: :asc).preload(:place)
    games = games.joins(place: [:city]).where('cities.id = ?', city.id) if city
    games
  end

  def open_for_reg?
  	max_people_number > members.count && max_teams_number > teams.count
  end

  def self.grouped_games city = nil, year_month = nil
    games = upcoming_games(city)
    games = games.where("to_char(games.when, 'YYYY-MM') = ?", year_month) if year_month.present?
    games.group_by.group_by{ |g| g.when.strftime("%d.%m.%Y") }
  end

  def max_score
    TeamRating.where(game_id: id).map(&:sum_points).sort.last
  end

  def calculate_team_ratings
    res = []
    if team_ratings.any?
      team_ratings.each do |tr|
        res << {game_id: self.id, team_id: tr.team.id, name: tr.team.name, scores: tr.sum_points}
      end
      max_scores = res.sort_by { |r| r[:scores] }.last[:scores]

      res.each {|r| r[:percent] = (r[:scores]/max_scores.to_f)*100.0}
    end

    res
  end

  def self.calculate_all_team_ratings
    Rails.cache.fetch("calculate_all_team_ratings", expires_in: 1.hours) do
      res = []
      all.each do |game|
        res << game.calculate_team_ratings if game.team_ratings.any?
      end
      res
    end
  end

  def self.import
    xlsx = Roo::Excelx.new("rating.xlsx")
    spreadsheet = xlsx.sheet(0)
    header = spreadsheet.row(1)

    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]

      game_num = row.values[10]
      game = Game.find_by(number: game_num) || Game.create(number: game_num)

      team_name = row.values[0].to_s.strip
      team = Team.find_by(name: team_name) || Team.create(name: team_name)
      begin
        unless GameRegistration.where(game_id: game.id, team_id: team.id).any?
          game.teams << team
          game.save
        end
      end


      team_rating = TeamRating.find_by(game_id: game.id, team_id: team.id)
      team_rating.update(round_one: row.values[1], round_two: row.values[2], round_three: row.values[3],
                         round_four: row.values[4], round_five: row.values[5], round_six: row.values[6],
                         round_seven: row.values[7])
    end
  end

protected

  def create_team_rating(obj)
    self.save
    TeamRating.create(game_id: self.id, team_id: obj.id)
  end
  
  def destroy_team_rating(obj)
    tr = team_ratings.where(game_id: self.id, team_id: obj.id).first
    tr.destroy if tr.present?
  end

end
