class AchievmentType < ApplicationRecord
	has_many :achievments, dependent: :nullify

	has_attached_file :image
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
end
