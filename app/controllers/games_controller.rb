class GamesController < ApplicationController
	def filter
		@game_groups = Game.grouped_games(City.find(params[:city_id]), params[:year_month])
		render 'games/index'
	end
end