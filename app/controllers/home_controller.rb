class HomeController < ApplicationController
  before_action :set_city

  def index

  end

  private
  def set_city
    @city = if current_user
      current_user.city || City.first
    else
      session[:city_id] ? City.find(session[:city_id]) : City.first
    end
  end

end
