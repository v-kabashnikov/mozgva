class AddSecretToTeam < ActiveRecord::Migration[5.0]
  def change
  	add_column :teams, :secret, :string
  end
end
