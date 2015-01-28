class UserMailer < ApplicationMailer
  def welcome_email(user_id)
    @user = User.find(user_id)
    mail to: @user.email, subject: t_scoped(:subject)
  end

  def password_reset_request(user)
    @name = user.name
    @email = user.email
    @token = user.reset_token
    mail to: @email, subject: t_scoped(:subject)
  end
end
