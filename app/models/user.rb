class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable
  belongs_to :city
  has_one :member, dependent: :destroy
  has_one :team, through: :member
  has_many :invitations, dependent: :destroy
  has_many :sent_invitations, class_name: 'Invitation', foreign_key: "inviter_id", dependent: :destroy

  def member? team
    team.users.include? self
  end

  def invited? team
    team.invited_users.include? self
  end

  def can_be_invited? team
    !self.team && !invited?(team)
  end

  def participate? game
    GameRegistration.find_by(team: self.team, game: game).present?
  end

  def accept invitation
    if invitation.user == self
      invitation.update(status: 'accepted') &&
        !invitation.team.add_member_checking(self).errors.present?
    else
      false
    end
  end

  def decline invitation
    invitation.user == self ? invitation.update(status: 'declined') : false
  end
end
