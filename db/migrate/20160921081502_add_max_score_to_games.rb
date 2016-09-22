class AddMaxScoreToGames < ActiveRecord::Migration[5.0]
  def change
  	add_column :team_ratings, :max_score, :integer
  end
end
