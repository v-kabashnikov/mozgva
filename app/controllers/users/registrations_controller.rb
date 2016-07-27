class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :html, :json
  before_action :set_team, only: [:new, :create]

  def new
  	flash[:errors] = []
    if @team
    	if !@team.full?
	      if current_user
	        Member.create(user: current_user, team: team)
	        return redirect_to my_team_path
	      end
	    else
	    	flash[:errors] << 'Команда уже заполнена :('
	    end
    elsif params[:invite].present?
      flash[:errors] << 'Неверный код инвайта'
    end
    super
  end

  def create
  	super
  	if resource && @team && !@team.full?
  		Member.create(user: resource, team: team)
  	end
  end

  private
  def set_team
  	@team = Team.find_by(invite: params[:invite]) if params[:invite].present?
  end

  def sign_up_params
    params.require(:user).permit(:name, :phone, :email, :password, :password_confirmation)
  end

  def account_update_params
    params.require(:user).permit(:name, :phone, :email, :password, :password_confirmation, :avatar)
  end
end
