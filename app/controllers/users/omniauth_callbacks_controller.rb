class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @user = User.from_omniauth(request.env["omniauth.auth"])
    if @user.persisted?
      team = Team.find_by(invite: session['devise.invite']) if session['devise.invite'].present?
      Invitation.create(user: @user, inviter: team.captain, team: team) if team && !team.full?
      sign_in_and_redirect @user, event: :authentication # this will throw if @user is not activated
      set_flash_message(:notice, :success, kind: "Facebook") if is_navigational_format?
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      errors = ['Ошибка при регистрации через соц. сеть'] + @user.errors.values.flatten
      redirect_to new_user_registration_url, flash: { errors: errors }
    end
  end

  def failure
    redirect_to root_path
  end
end
