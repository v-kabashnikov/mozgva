class AddPhoneConfiramtionToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :phone_confirmed_at, :datetime
    add_column :users, :confiramtion_code, :string
  end
end
