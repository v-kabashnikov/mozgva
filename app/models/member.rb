class Member < ApplicationRecord
  belongs_to :user
  belongs_to :team
  before_create :delete_invitations

  validates_with MembersCountValidator
  # validates :team, uniqueness: { scope: :user, message: "user can be in team only once" }
  validates :user, uniqueness: { message: "user can be only in one team" }

  def captain?
    team_role == 'captain'
  end

  private
  def delete_invitations
  	Invitation.where(user: user, team: team).destroy_all
  end
end
