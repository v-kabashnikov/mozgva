class Member < ApplicationRecord
  belongs_to :user
  belongs_to :team

  validates_with MembersCountValidator
  # validates :team, uniqueness: { scope: :user, message: "user can be in team only once" }
  validates :user, uniqueness: { message: "user can be only in one team" }

  def captain?
    team_role == 'captain'
  end
end
