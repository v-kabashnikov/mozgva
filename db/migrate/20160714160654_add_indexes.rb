class AddIndexes < ActiveRecord::Migration[5.0]
  def change
    add_index :leagues, :name, unique: true
    add_index :teams, :name, unique: true
    add_index :teams, :invite, unique: true
  end
end
