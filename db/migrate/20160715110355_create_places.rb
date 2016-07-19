class CreatePlaces < ActiveRecord::Migration[5.0]
  def change
    create_table :places do |t|
      t.string :name
      t.string :site
      t.string :address
      t.references :city, foreign_key: true

      t.timestamps
    end
  end
end
