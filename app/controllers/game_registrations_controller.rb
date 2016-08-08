class GameRegistrationsController < ApplicationController

	def create
		@game = Game.find(params[:game_id])
		team = current_user.team
		if team
			@gr = GameRegistration.new(game: @game, team: team)
			phone = Phone.new(team.captain.phone)
			if phone.valid?
				number = team.members_count   
				msg = "Команда \"#{team.name}\" (#{number} #{Russian.p(number, "человек", "человека", "человек")}) зарегистрирована на Мозгву #{@game.when.strftime('%d.%m.%y')}. Ждем Вас!"
				sms = SmsTwilio.new.send(phone.formatted_phone, msg)
			end
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