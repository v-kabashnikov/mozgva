class AddQuestionSetToGames < ActiveRecord::Migration[5.0]
  def change
  	add_column :games, :question_set, :integer
  end
end
