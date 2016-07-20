class Game < ApplicationRecord
  belongs_to :place
  belongs_to :league
  has_one :city, through: :place
  has_many :game_registrations, dependent: :destroy
  has_many :teams, through: :game_registrations
  has_many :members, through: :teams
  
  enum status: { 'checking' => 'checking', 'open' => 'open', 'canceled' => 'canceled', 'ended' => 'ended' }

  validates_presence_of :max_people_number, :max_teams_number
  validates_uniqueness_of :number

  def self.upcoming_games city = nil
  	games = open.where('games.when > ?', Time.now).order(when: :asc).preload(:place)
    games = games.joins(place: [:city]).where('cities.id = ?', city.id) if city
    games
  end

  def open_for_reg?
  	max_people_number > members.count && max_teams_number > teams.count
  end
end
