class TeamRating < ApplicationRecord
  belongs_to :team
  belongs_to :game

  rails_admin do
    edit do
      field :team
      fields :round_one, :round_two, :round_three, :round_four, :round_five, :round_six, :round_seven
    end
  end

  def sum_points
  	round_one + round_two + round_three + round_four + round_five + round_six + round_seven
  end
end
