class TeamRatingsController < ApplicationController

	def rating
		t = Time.now
		result = Game.calculate_all_team_ratings
		g = (Time.now - t).to_s
		@ratings = Team.pick_up_team_ratings(result)
		p (Time.now - t).to_s
		p g
	end

end