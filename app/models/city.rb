class City < ApplicationRecord
	has_many :places, dependent: :nullify
	
	validates_presence_of :name
end
