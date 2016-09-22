class ChangeTeamRatingsScoresToSevenRounds < ActiveRecord::Migration[5.0]
  def change
  	remove_column :team_ratings, :scores, :integer
  	add_column :team_ratings, :round_one, :integer, default: 0
  	add_column :team_ratings, :round_two, :integer, default: 0
  	add_column :team_ratings, :round_three, :integer, default: 0
  	add_column :team_ratings, :round_four, :integer, default: 0
  	add_column :team_ratings, :round_five, :integer, default: 0
  	add_column :team_ratings, :round_six, :integer, default: 0
  	add_column :team_ratings, :round_seven, :integer, default: 0
  end
end
