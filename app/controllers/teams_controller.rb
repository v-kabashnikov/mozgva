class TeamsController < ApplicationController
  before_action :authenticate_user!, except: [:list]

  def create
    if current_user.phone_confirmed_at
      team = Team.new(team_params)
      if team.save
        member = Member.new(user: current_user, team: team, team_role: 'captain')
        if member.save
          request.xhr? ? render(json: { status: 'ok' }) : redirect_to(my_team_path)
        else
          flash[:errors] = member.errors.full_messages
          request.xhr? ? render(json: { status: 'error', errors: flash[:errors] }, status: 406 ) : redirect_back(fallback_location: index_path)
        end
      else
        flash[:errors] = team.errors.full_messages
        request.xhr? ? render(json: { status: 'error', errors: flash[:errors] }, status: 406 ) : redirect_back(fallback_location: index_path)
      end
    else
      flash[:errors] = ['У вас не подтвержден телефон']
      request.xhr? ? render(json: { status: 'error', errors: flash[:errors] }, status: 406 ) : redirect_back(fallback_location: index_path)
    end
  end

  def my_team
    set_city
    @team = current_user.team
    return redirect_to root_path unless @team
    @past_games = Game.joins(:game_registrations).where("game_registrations.team_id" => @team.id).where('"when" < :now', now: DateTime.now)
    @month_array =[]
    @past_games.each do |game|
      @month_array << game.when.strftime("%m").to_i
    end
    @month_array = @month_array.uniq
    render 'show'
  end

  def update
    @team = Team.find(params[:id])
    if @team.update(team_params)
      request.xhr? ? render(json: { status: 'ok', team: @team }) : redirect_back(fallback_location: my_team_path)
    else
      flash[:errors] = @team.errors.full_messages
      request.xhr? ? render(json: { status: 'error', errors: flash[:errors] }, status: 406 ) : redirect_back(fallback_location: my_team_path)
    end
  end

  def list
    @teams = Game.find(params[:game_id]).teams
  end

  private

  def team_params
    params[:team].permit(:name, :league_id)
  end
end
