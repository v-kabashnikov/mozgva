class HomeController < ApplicationController
  before_action :set_city

  def index
  	@curr_month = [Date.today.strftime('%Y-%m'), MONTH_NAMES[Date.today.strftime('%m').to_i - 1]]
    @game_groups = Game.grouped_games(@city, @curr_month.first)
    @months = Game.select("to_char(games.when, 'YYYY-MM') as month").distinct.order('month').map{|m| [m.month, MONTH_NAMES[m.month.split('-').second.to_i-1]]}
    @main_games = Game.main.order(:when)
  end

end
