class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable, :omniauthable, omniauth_providers: [:facebook]
  belongs_to :city
  has_one :member, dependent: :destroy
  has_one :team, through: :member
  has_many :invitations, dependent: :destroy
  has_many :sent_invitations, class_name: 'Invitation', foreign_key: "inviter_id", dependent: :destroy
  has_many :omnilinks, dependent: :destroy

  has_attached_file :avatar, styles: { small: "400x400#", thumb: "140x140#" }
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/

  def member? team
    team.users.include? self
  end

  def generate_confirmation_code
    code = (1..4).map{rand(0..9).to_s}.join
    update(confirmation_code: code)
    code
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

  def self.from_omniauth(auth)
    ol = Omnilink.find_by(provider: auth.provider, uid: auth.uid)
    user = if ol
      ol.user
    else
      u = User.new(
        email: auth.info.email,
        password: Devise.friendly_token[0,20],
        name: auth.info.name,
        avatar: open(auth.info.image + '?width=400&height=400', allow_redirections: :safe)
      )
      if u.save
        Omnilink.create(user: u, provider: auth.provider, uid: auth.uid)
      end
      u
    end
  end

end
