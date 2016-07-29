class Game < ApplicationRecord
  belongs_to :place
  belongs_to :league
  has_one :city, through: :place
  has_many :photos
  has_many :game_registrations, dependent: :destroy
  has_many :teams, through: :game_registrations
  has_many :members, through: :teams

  accepts_nested_attributes_for :photos, :allow_destroy => true


  enum status: { 'checking' => 'checking', 'open' => 'open', 'canceled' => 'canceled', 'ended' => 'ended' }

  scope :main, ->{ where main: true }

  validates_presence_of :max_people_number, :max_teams_number
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
end
