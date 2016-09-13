class TeamRatingsController < ApplicationController
	def rating
		result = Game.calculate_all_team_ratings
		# @top, @pretendents = Team.pick_up_team_ratings(result)
		@top, @pretendents = Team.sql_pick_up_team_ratings
		@top.sort! {|a, q| q[:percent] <=> a[:percent]}
		@pretendents.sort! {|a, q| q[:percent] <=> a[:percent]}
	end
end