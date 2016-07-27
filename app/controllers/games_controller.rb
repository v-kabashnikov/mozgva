class GamesController < ApplicationController
	def filter
		@game_groups = Game.grouped_games(City.find(params[:city_id]), params[:year_month])
		render 'games/index'
	end

	def unregister
		@game = Game.find(params[:id])
		@gr = GameRegistration.find_by(game: @game, team: current_user.team)
		@gr.destroy
		render 'game_registrations/change'
	end
end