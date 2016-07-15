class Place < ApplicationRecord
	belongs_to :city
	has_many :games, dependent: :nullify
	
	validates_presense_of :name
end
