class GameRegistration < ApplicationRecord
  belongs_to :team, optional: false
  belongs_to :game, optional: false

  validates :team, uniqueness: { scope: :game, message: "team already registered for this game" }
end
