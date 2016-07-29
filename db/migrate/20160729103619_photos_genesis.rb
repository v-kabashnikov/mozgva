class PhotosGenesis < ActiveRecord::Migration[5.0]
  def change
    drop_table :photos, if_exists: true
    create_table :photos do |t|
      t.belongs_to :game, index: true
      t.attachment :image
      t.string :caption
      t.timestamps
    end
  end
end
