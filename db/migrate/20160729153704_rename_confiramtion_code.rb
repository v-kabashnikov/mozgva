class RenameConfiramtionCode < ActiveRecord::Migration[5.0]
  def change
  	rename_column :users, :confiramtion_code, :confirmation_code
  end
end
