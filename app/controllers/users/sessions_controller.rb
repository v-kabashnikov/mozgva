class Users::SessionsController < Devise::SessionsController
  respond_to :html, :json

  def create
  	super
  	@team = Team.find_by(invite: session['devise.invite']) if session['devise.invite'].present?
  	if resource && @team && !@team.full?
  		Invitation.create(user: resource, inviter: @team.captain, team: @team)
  	end
  end
end