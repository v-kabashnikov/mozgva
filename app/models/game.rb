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
  validates_uniqueness_of :number

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

  def calculate_team_ratings
    res = []
    if team_ratings.any?
      team_ratings.each do |tr|
        res << {game_id: self.id, team_id: tr.team.id, name: tr.team.name, scores: tr.sum_points}
      end
      #same_games = Game.where(number: self.number)
      max_scores = res.sort_by { |r| r[:scores] }.last[:scores]

      res.each {|r| r[:percent] = (r[:scores]/max_scores.to_f)*100.0}
    end

    res
  end

  def self.calculate_all_team_ratings
    res = []
    
    all.each do |game|
      res << game.calculate_team_ratings if game.team_ratings.any?
    end
    res
  end

  def self.import
    xlsx = Roo::Excelx.new("rating.xlsx")
    spreadsheet = xlsx.sheet(0)
    header = spreadsheet.row(2)

    game_parsing = true

    (2..spreadsheet.last_row).each do |i|
      if !spreadsheet.row(i).first.nil? && !spreadsheet.row(i)[1].nil?
        row = Hash[[header, spreadsheet.row(i)].transpose]

        if game_parsing
          game_num = row.values[0].is_a?(String) ? row.values[0].split.last : row.values[0].to_s
          game = Game.find_by(number: game_num) || Game.create(number: game_num)
          game_parsing = false
        else
          team_name = row.values[0]
          team = Team.find_by(name: team_name) || Team.create(name: team_name)
          game.teams << team
          game.save

          team_rating = TeamRating.find_by(game_id: game.id, team_id: team.id)
          team_rating.update(round_one: h[1], round_two: h[2], round_three: h[3],
                   round_four: h[4], round_five: h[5], round_six: h[6],
                   round_seven: h[7])
        end
      else
        game_parsing = true
      end
    end
  end

  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
    when ".csv" then Roo::Csv.new(file.path, nil, :ignore)
    when ".xls" then Roo::Excel.new(file.path, nil, :ignore)
    when ".xlsx" then Roo::Excelx.new(file.path, nil, :ignore)
    else raise "Unknown file type: #{file.original_filename}"
    end
  end

protected

  def create_team_rating(obj)
    puts obj.id
    TeamRating.create(game_id: self.id, team_id: obj.id)
  end
  
  def destroy_team_rating(obj)
    tr = team_ratings.where(game_id: self.id, team_id: obj.id).first
    tr.destroy if tr.present?
  end

end
