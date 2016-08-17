class TeamRatingsController < ApplicationController

	def rating
		result = Game.calculate_all_team_ratings
		@ratings = Team.pick_up_team_ratings(result)
	end

end