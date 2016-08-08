class CreateAchievmentTypes < ActiveRecord::Migration[5.0]
  def change
    create_table :achievment_types do |t|
      t.string :name
      t.attachment :image

      t.timestamps
    end
  end
end
