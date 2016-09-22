class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :get_invitations

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to main_app.new_user_session_path, alert: exception.message
  end

  private
  def set_city
    @city = if current_user
      current_user.city || City.first
    else
      City.find_by(id: session[:city_id]) || City.first
    end
  end

  def get_invitations
    @invitations = current_user.invitations.waiting if current_user
  end

  def inv
    unless current_user.team
      if @invitations.present?
        $INV = true
      else
        $INV = false
      end
    end
  end
end
