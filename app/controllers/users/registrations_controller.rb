class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :html, :json
  before_action :set_team, only: [:new, :create]

  def new
  	flash[:errors] = []
    if @team
    	if !@team.full?
	      if current_user
          Invitation.create(user: current_user, inviter: @team.captain, team: @team))
	        return redirect_to root_path
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
    phone = Phone.new(params[:user][:phone])
    if params[:user][:phone].present? && phone.valid?
      current_user.update(phone: phone.formatted_phone)
      code = current_user.generate_confirmation_code
      sms = SmsTwilio.new.send(phone.formatted_phone, code)
      info = sms.info
      if sms.status == 'ok'
        render json: { status: :ok, user: { phone: current_user.phone } }
      else
        render json: { status: :error, error: 'Ошибка при отправке SMS' }, status: 500
      end
    else
      render json: { status: :error, errors: { phone: 'Неверный формат телефона' } }, status: 406
    end
  end

  def check_confirmation
    if params[:code].present? && params[:code] == current_user.confirmation_code
      current_user.update(phone_confirmed_at: Time.now, confirmation_code: nil)
      render json: { status: :ok }
    else
      render json: { status: :errors, errors: { code: 'Неверный код' } }, status: 406
    end
  end

  def create
  	super
  	if resource && @team && !@team.full?
      Invitation.create(user: current_user, inviter: @team.captain, team: @team))
  		# Member.create(user: resource, team: @team)
  	end
  end

  private
  def update_resource(resource, params)
    method = params[:password].present? ? :update_with_password : :update_without_password
    resource.send(method, params)
  end

  def set_team
  	@team = Team.find_by(invite: session[:invite]) if session[:invite].present?
  end

  def sign_up_params
    params.require(:user).permit(:name, :phone, :email, :password, :password_confirmation)
  end

  def account_update_params
    fields = [:name, :phone, :avatar, :email]
    fields += [:password, :password_confirmation, :current_password] if params[:user][:password].present?
    params.require(:user).permit(fields)
  end
end
