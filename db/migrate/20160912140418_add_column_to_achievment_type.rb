class AddColumnToAchievmentType < ActiveRecord::Migration[5.0]
  def change
    add_column :achievment_types, :about, :text
  end
end
