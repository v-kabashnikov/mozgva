class Member < ApplicationRecord
  default_scope ->{ order('members.team_role IS NULL, members.team_role DESC')}
  belongs_to :user
  belongs_to :team
  # after_create :delete_invitations

  validates_with MembersCountValidator
  # validates :team, uniqueness: { scope: :user, message: "user can be in team only once" }
  validates :user, uniqueness: { message: "user can be only in one team" }

  def captain?
    team_role == 'captain'
  end

  def boatswain?
    team_role == 'boatswain'
  end

  private
  def delete_invitations
    # Invitation.where(user: user, team: team).destroy_all
  	Invitation.where(user: user).destroy_all
  end
end
