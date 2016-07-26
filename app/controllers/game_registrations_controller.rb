class GameRegistrationsController < ApplicationController

	def create
		@game = Game.find(params[:game_id])
		team = current_user.team
		if team
			@gr = GameRegistration.new(game: @game, team: team)
			unless @gr.save
				@gr = nil
				flash[:modal_errors] = @gr.errors.messages
			end
		else
			flash[:modal_errors] = ["Необходимо сперва вступить в команду или создать свою"]
		end
		render 'change'
	end

end