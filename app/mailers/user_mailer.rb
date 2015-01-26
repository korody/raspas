class UserMailer < ApplicationMailer
  def welcome_email(user_id)
    @user = User.find(user_id)
    mail to: @user.email, subject: t_scoped(:subject)
  end
end
