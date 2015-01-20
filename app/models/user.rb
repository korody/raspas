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

private

  def set_username
    self.username = display_username.downcase
  end

  def downcase_email
    email.downcase!
  end
end
