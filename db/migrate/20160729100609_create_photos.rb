class CreatePhotos < ActiveRecord::Migration[5.0]
  def change
    create_table :photos do |t|
      t.belongs_to :game, index: true
      t.attachment :file
      t.string :caption
      t.timestamps
    end
  end
end
