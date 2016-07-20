class HomeController < ApplicationController
  before_action :set_city

  def index
    @game_groups = Game.upcoming_games(@city).group_by.group_by{|g| g.when.strftime("%d.%m.%Y")}
    @main_games = Game.all.sample(rand(1..3))
  end

  private
  def set_city
    @city = if current_user
      current_user.city || City.first
    else
      City.find_by(id: session[:city_id]) || City.first
    end
  end

end
