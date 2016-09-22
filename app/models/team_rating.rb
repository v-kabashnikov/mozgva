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
  	round_one.to_f + round_two.to_f + round_three.to_f + round_four.to_f + round_five.to_f + round_six.to_f + round_seven.to_f
  end
end
