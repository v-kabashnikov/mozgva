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

  def send_confirmation
    current_user.update(account_update_params)
    code = current_user.generate_confirmation_code
    # send_code(code)
  end

  def check_confirmation
    if params[:code].present? && params[:code] == current_user.code
      current_user.update(phone_confirmed_at: Time.now)
      render json: { status: :ok }
    else
      render json: { status: :error, code: 'Неверный код' }
    end
  end

  def create
  	super
  	if resource && @team && !@team.full?
  		Member.create(user: resource, team: @team)
  	end
  end

  private
  def update_resource(resource, params)
    method = params[:password].present? ? :update_with_password : :update_without_password
    resource.send(method, params)
  end

  def set_team
  	@team = Team.find_by(invite: params[:invite]) if params[:invite].present?
  end

  def sign_up_params
    params.require(:user).permit(:name, :phone, :email, :password, :password_confirmation)
  end

  def account_update_params
    fields = [:name, :phone, :avatar, :email]
    fields + [:password, :password_confirmation, :current_password] if params[:password].present?
    params.require(:user).permit(fields)
  end
end
