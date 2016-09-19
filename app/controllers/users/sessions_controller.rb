class Users::SessionsController < Devise::SessionsController
  respond_to :html, :json
  after_action :inv, only: [:create]
  before_action :set_waiting_invitations, only: [:create]

  def create
  	super
  	@team = Team.find_by(invite: session['devise.invite']) if session['devise.invite'].present?
  	if resource && @team && !@team.full?
  		Invitation.create(user: resource, inviter: @team.captain, team: @team)
  	end
  end

  private

  def inv
    unless current_user.team
      if @waiting_invitations.present?
        $INV = true
      else
        $INV = false
      end
    end
  end
end
