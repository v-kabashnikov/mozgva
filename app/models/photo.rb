class Photo < ApplicationRecord
  belongs_to :game

  has_attached_file :image, :styles => { :detailed => "1920x1920>", :thumb => "100x100>" }
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
end
