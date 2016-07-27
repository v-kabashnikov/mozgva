class AddTeamRoleToMember < ActiveRecord::Migration[5.0]
  def change
    add_column :members, :team_role, :string
  end
end
