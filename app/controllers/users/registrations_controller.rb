class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :html, :json

  def create
  	super
    UserMailer.password_email(resource).deliver_now if resource.persisted?
  end

  protected
  def sign_up_params
    super.merge(password: Devise.friendly_token.first(8))
  end
end
