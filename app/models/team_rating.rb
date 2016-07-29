class TeamRating < ApplicationRecord
  belongs_to :team
  belongs_to :game

  validates_presence_of :scores, :team_id, :game_id

  rails_admin do
    edit do
      field :scores
      field :team
    end
  end
end
