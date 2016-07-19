class UsersController < ApplicationController
  before_action :authenticate_user!, except: [:update_city]
	
	def search
		@user = User.find_by(email: params[:email])
	end

	def update_city
		current_user ? current_user.update(city_id: params[:city_id]) : session[:city_id] = params[:city_id]
		render json: { status: :ok }
	end
end