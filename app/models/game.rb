class Game < ApplicationRecord
  belongs_to :place
  belongs_to :league
  has_one :city, through: :place
  
  enum status: { 'checking' => 'checking', 'open' => 'open', 'canceled' => 'canceled', 'ended' => 'ended' }

  validates_presense_of :max_people_number, :max_teams_number
end
