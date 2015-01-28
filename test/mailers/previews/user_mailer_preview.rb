# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  def password_reset_request
    user = User.first
    user.reset_token = '123'
    UserMailer.password_reset_request(user)
  end

  def welcome_email
    user = User.first
    UserMailer.welcome_email(user.id)
  end
end
