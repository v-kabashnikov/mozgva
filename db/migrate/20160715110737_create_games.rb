class CreateGames < ActiveRecord::Migration[5.0]
  def change
    create_table :games do |t|
      t.integer :number
      t.references :place, foreign_key: true
      t.string :name
      t.references :league, foreign_key: true
      t.integer :price
      t.datetime :when
      t.string :status, null: false, default: Game.statuses.keys.first
      t.integer :max_people_number
      t.integer :max_teams_number

      t.timestamps
    end
  end
end
