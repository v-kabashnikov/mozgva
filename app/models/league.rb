class League < ApplicationRecord
  has_many :teams, dependent: :nullify
  has_many :games, dependent: :nullify
end
