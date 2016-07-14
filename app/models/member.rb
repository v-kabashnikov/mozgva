class Member < ApplicationRecord
  belongs_to :user
  belongs_to :team

  validate :number_of_members_in_team
  # validates :team, uniqueness: { scope: :user, message: "user can be in team only once" }
  validates :user, uniqueness: { message: "user can be only in one team" } 
  validates_uniqueness_of :team, scope: [:user]

  private
  def number_of_members_in_team
    if team.members_count >= Team::MAX_MEMBERS_COUNT
      errors.add(:team, "team is full")
    end
  end
end
