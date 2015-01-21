class User < ActiveRecord::Base
  include UsesSecurePassword

  validates :name, presence: true, length: { maximum: 60 }
  validates :display_username, presence: true, length: { minimum: 2, maximum: 15 }, uniqueness: { case_sensitive: false }, username_format: true
  validates :email, presence: true, length: { maximum: 60 }, uniqueness: { case_sensitive: false }, email_format: true

  has_many :authentications

  uses_secure_password validate: false

  before_save :set_username, :downcase_email

  def to_param
    display_username
  end

  def self.from_omniauth(auth)
    where(email: auth.info.email).first_or_create! do |user|
      user.email = auth.info.email
      user.name = auth.info.name
      user.image = auth.extra.raw_info.image
    end
  end

private

  def set_username
    self.username = display_username.downcase
  end

  def downcase_email
    email.downcase!
  end
end
