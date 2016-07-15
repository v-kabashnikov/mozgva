class City < ApplicationRecord
	has_many :places, dependent: :nullify
	
	validates_presense_of :name
end
