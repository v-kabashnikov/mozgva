class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  private
  def set_city
    @city = if current_user
      current_user.city || City.first
    else
      City.find_by(id: session[:city_id]) || City.first
    end
  end
end
