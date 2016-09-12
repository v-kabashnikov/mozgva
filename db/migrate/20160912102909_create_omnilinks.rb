class CreateOmnilinks < ActiveRecord::Migration[5.0]
  def change
    create_table :omnilinks do |t|
      t.references :user, foreign_key: true
      t.string :provider
      t.string :uid

      t.timestamps
    end
  end
end
