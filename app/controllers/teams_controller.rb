class TeamsController < ApplicationController
  before_action :authenticate_user!, except: [:list, :show]

  def show
    @rating = Team.sql_pick_up_team_ratings
    @teams_top = @rating.first.first(10)
    @team = Team.find(params[:id]).with_scores_and_percent || Team.find(params[:id])
    @past_games = Game.joins(:game_registrations).where("game_registrations.team_id" => @team.id).where('"when" < :now', now: DateTime.now).order('"when" DESC')
    @last_game = Game.where('"when" < :now', now: DateTime.now).order(when: :asc).joins('left join photos on photos.game_id=games.id').last
    @month_array =[]
    @past_games.each do |game|
      @month_array << game.when.strftime("%m").to_i
    end
    @month_array = @month_array.uniq
  end

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
    @rating = Team.sql_pick_up_team_ratings
    @teams_top = @rating.first.first(10)
    @team = current_user.team.with_scores_and_percent
    @main_games = Game.main.order(:when)
    return redirect_to root_path unless @team
    @past_games = Game.joins(:game_registrations).where("game_registrations.team_id" => @team.id).where('"when" < :now', now: DateTime.now).order('"when" DESC')
    @month_array =[]
    @past_games.each do |game|
      @month_array << game.when.strftime("%m").to_i
    end
    @month_array = @month_array.uniq
    @last_game = Game.where('"when" < :now', now: DateTime.now).order(when: :asc).joins('left join photos on photos.game_id=games.id').last
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

  def take
    @team = Team.find(params[:id])
    if @team.secret.present? && @team.secret == params[:team][:secret]
      if current_user.team
        current_user.member.destroy
      end
      member = Member.create(team: @team, user: current_user, team_role: :captain)
      @team.update(secret: nil) if member.persisted?
      render json: { status: 'ok' }
    else
      render json: { error: 'Неверный секретный код' }, status: 403 
    end
  end

  def destroy
    @team = Team.find(params[:id])
    @team.destroy
    redirect_to root_url
  end

  # def time
  #   @curr_month = [Date.today.strftime('%Y-%m'), MONTH_NAMES[Date.today.strftime('%m').to_i - 1]]
  #   @game_groups = Game.grouped_games(@city, @curr_month.first)
  #   @game_groups_count = @game_groups.count
  #   @game_groups = @game_groups.first(4)
  #   @months = Game.where('games.when > ?', Time.now).select("to_char(games.when, 'YYYY-MM') as month").distinct.order('month').map{|m| [m.month, MONTH_NAMES[m.month.split('-').second.to_i-1]]}
  #   @main_games = Game.main.order(:when)
  #   @past_games = Game.where('"when" < :now', now: DateTime.now)
  # end

  private

  def team_params
    params[:team].permit(:name, :league_id)
  end
end
