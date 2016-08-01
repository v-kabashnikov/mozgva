class CreateAchievments < ActiveRecord::Migration[5.0]
  def change
    create_table :achievments do |t|
      t.references :team, foreign_key: true
      t.references :achievment_type, foreign_key: true
      t.date :date

      t.timestamps
    end
  end
end
