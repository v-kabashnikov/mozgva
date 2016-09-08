class Users::SessionsController < Devise::SessionsController
  respond_to :html, :json

  def create
  	super
  	@team = Team.find_by(invite: session[:invite]) if session[:invite].present?
  	if resource && @team && !@team.full?
  		Invitation.create(user: current_user, inviter: @team.captain, team: @team))
			# Member.create(user: resource, team: @team)
  	end
  end
end