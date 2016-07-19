class Invitation < ApplicationRecord
  belongs_to :team
  belongs_to :user
  belongs_to :inviter, class_name: User, optional: true

  enum status: { 'waiting' => 'waiting', 'accepted' => 'accepted', 'declined' => 'declined', 'expired' => 'expired' }

  validates_with MembersCountValidator
  validate :invited_by_self, :invited_by_not_member
  validate :already_member, :already_invited, on: :create

  private
  def invited_by_self
    if user == inviter
      errors.add(:user, "user can't invite himself")
    end
  end
  def invited_by_not_member
    if inviter && !inviter.member?(team)
      errors.add(:user, "inviter is not member of the team")
    end
  end
  def already_member
    if user.member? team
      errors.add(:user, "user already member")
    end
  end
  def already_invited
    if user.invited? team
      errors.add(:user, "user already invited to the team")
    end
  end
end
