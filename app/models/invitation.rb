class Invitation < ApplicationRecord
  belongs_to :team
  belongs_to :user
  belongs_to :inviter, class_name: User, optional: true
  
  enum status: { 'waiting' => 'waiting', 'accepted' => 'accepted', 'declined' => 'declined', 'expired' => 'expired' }

  validate :number_of_members_and_invitations_in_team

  private
  def number_of_members_and_invitations_in_team
    if team.members_count + team.invitations_count >= Team::MAX_MEMBERS_COUNT
      errors.add(:team, "team is full")
    end
  end
end
