class UserCreationService
  def self.create(params, mailer: nil)
    new(mailer).create(params)
  end

  def initialize(mailer = nil)
    @mailer = mailer
  end

  def create(params)
    User.create(params).tap do |user|
      if user.valid?
        welcome_mailer.welcome_email(user.id).deliver_now
      end
    end
  end

private

  def welcome_mailer
    @mailer || UserMailer
  end
end
