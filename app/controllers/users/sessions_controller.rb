class Users::SessionsController < Devise::SessionsController
  respond_to :html, :json

  def create
  	super
  	@team = Team.find_by(invite: params[:invite]) if params[:invite].present?
  	if resource && @team && !@team.full?
  		Member.create(user: resource, team: @team)
  	end
  end
end