class TeamRatingsController < ApplicationController

	def rating
		@ratings = []

		result = []
		Game.all.each do |game|
			result << game.calculate_team_ratings
		end

		Team.all.each do |team|
			t_scores = 0
			t_percent = 0.0
			t_games = 0
			result.each do |r|
				if r.any?
					t = r.find{|i| i[:name] == team.name}
					t_scores += t[:scores]
					t_percent += t[:percent]
					t_games += 1
				end
			end

			if t_games > 0
				average_percent = t_percent / t_games.to_f
				@ratings << {name: team.name, scores: t_scores, percent: average_percent, games: t_games}
			end
		end
	end

end