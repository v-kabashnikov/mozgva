class CreateTeamRatings < ActiveRecord::Migration[5.0]
  def change
    create_table :team_ratings do |t|
      t.integer :scores, default: 0
      t.references :team, index: true
      t.references :game, index: true

      t.timestamps
    end
  end
end
