class AddMainToGame < ActiveRecord::Migration[5.0]
  def change
    add_column :games, :main, :boolean, null: false, default: false
  end
end
