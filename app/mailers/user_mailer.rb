class UserMailer < ApplicationMailer
	URL = ENV['HOST']
	def password_email user
		@user, @url = user, URL
    mail(to: @user.email, subject: 'Успешная регистрация на сайте')
	end
end