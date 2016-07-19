class UsersController < ApplicationController
  before_action :authenticate_user!
	
	def search
		@user = User.find_by(email: params[:email])
	end
end