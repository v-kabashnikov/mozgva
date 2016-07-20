class TeamsController < ApplicationController
  before_action :authenticate_user!, except: [:list]

  def create
    team = Team.new(team_params)
    if team.save
      member = Member.new(user: current_user, team: team)
      if member.save
        redirect_to my_team_path
      else
        flash[:errors] = member.errors.messages
        redirect_back(fallback_location: index_path)
      end
    else
      flash[:errors] = team.errors.messages
      redirect_back(fallback_location: index_path)
    end
  end

  def my_team
    @team = current_user.team
    render 'show'
  end

  def list
    @teams = Game.find(params[:game_id]).teams
  end

  private

  def team_params
    params[:team].permit(:name, :league_id)
  end
end
