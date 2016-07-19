class CreateInvitations < ActiveRecord::Migration[5.0]
  def change
    create_table :invitations do |t|
      t.references :team, foreign_key: true
      t.references :user, foreign_key: true
      t.integer :inviter_id
      t.string :status, null: false, default: Invitation.statuses.keys.first

      t.timestamps
    end
    add_foreign_key :invitations, :users, column: :inviter_id
  end
end
