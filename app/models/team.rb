class Team < ApplicationRecord
  MAX_MEMBERS_COUNT = 9

  belongs_to :league, optional: true
  has_many :members, dependent: :destroy
  has_many :users, through: :members
  has_many :invitations, dependent: :destroy

  before_create :set_invite

  validates :name, presence: true, uniqueness: true

  def generate_invite
    values = ('a'..'z').to_a + ('A'..'Z').to_a + (0..9).to_a
    (1..5).map{ values.sample.to_s }.join
  end

  def members_count
    members.count
  end

  def invitations_count
    invitations.count
  end

  def add_member user
    Member.create(user: user, team: self)
  end

  def invite_member user, inviter
    Invitation.create(user: user, inviter: inviter, team: self)
  end

  private
  def set_invite
    self.invite = loop do
      inv = generate_invite
      break inv unless Team.find_by_invite inv
    end
  end
end
