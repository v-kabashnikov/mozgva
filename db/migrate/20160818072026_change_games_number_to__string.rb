class ChangeGamesNumberToString < ActiveRecord::Migration[5.0]
  def up
    change_column :games, :number, :string
  end

  def down
    change_column :games, :number, :integer
  end
end
