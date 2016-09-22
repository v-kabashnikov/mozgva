class AddAvatarAndPhoneToUser < ActiveRecord::Migration[5.0]
  def change
  	add_attachment :users, :avatar
  	add_column :users, :phone, :string
  end
end
