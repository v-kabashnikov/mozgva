class League < ApplicationRecord
  has_many :teams, dependent: :nullify
end
