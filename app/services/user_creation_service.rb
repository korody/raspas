class UserCreationService
  def self.create(params, auth = nil)
    new.create(params)
  end

  def initialize(mailer = nil)
    @mailer = mailer
  end

  def create(params, auth = nil)
    User.new(params) do |user|
      user.add_auth(auth) if auth

      if user.save
        welcome_mailer.welcome_email(user).deliver_later
      end
    end
  end

private

  def welcome_mailer
    @mailer || UserMailer
  end
end
