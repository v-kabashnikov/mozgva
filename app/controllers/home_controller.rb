class HomeController < ApplicationController
  before_action :set_city
  before_action :set_calend_vars, only: [:index, :calendar]

  def index
    @game_groups_count = @game_groups.count
    @game_groups = @game_groups.first(4)
    @main_games = Game.main.where('games.when > ?', Time.now).order(:when)
    @past_games = Game.where('"when" < :now', now: DateTime.now)
  end

  def set_calend_vars
    @curr_month = [Date.today.strftime('%Y-%m'), MONTH_NAMES[Date.today.strftime('%m').to_i - 1]]
    @game_groups = Game.grouped_games(@city, @curr_month.first)
    @months = Game.where('games.when > ?', Time.now).select("to_char(games.when, 'YYYY-MM') as month").distinct.order('month').map{|m| [m.month, MONTH_NAMES[m.month.split('-').second.to_i-1]]}
    @waiting_invitations = current_user.invitations.waiting if current_user
  end

end
