class TeamsController < ApplicationController
  def create
    Team.create(team_params)
    
  end

  private

  def team_params
    params[:team].permit(:name, :league_id)
  end
end