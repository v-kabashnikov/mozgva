class TeamsController < ApplicationController
  before_action :authenticate_user!

  def create
    team = Team.create(team_params)
    team.add_member(current_user)
    redirect_to my_team_path
  end

  def my_team
  	@team = current_user.team
  	render 'show'
  end

  private

  def team_params
    params[:team].permit(:name, :league_id)
  end
end