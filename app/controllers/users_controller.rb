class UsersController < ApplicationController
  before_action :authenticate_user!, except: [:update_city]

	def search
		@user = User.find_by(email: params[:email])
	end

	def update_city
		current_user ? current_user.update(city_id: params[:city_id]) : session[:city_id] = params[:city_id]
		@curr_month = [Date.today.strftime('%Y-%m'), MONTH_NAMES[Date.today.strftime('%m').to_i - 1]]
		@city = City.find(params[:city_id])
		@game_groups = Game.grouped_games(@city, params[:year_month])
    @game_groups_count = @game_groups.count
    @game_groups = @game_groups.first(params[:max_groups].to_i) if params[:max_groups].present?
		render 'games/index'
	end
end
