class User < ActiveRecord::Base
  include UsesSecurePassword

  validates :first_name, :last_name, presence: true, length: { maximum: 35 }
  validates :display_username, presence: true, length: { minimum: 2, maximum: 15 }, uniqueness: { case_sensitive: false }, username_format: true
  validates :email, presence: true

  has_many :authentications

  uses_secure_password validate: false

  before_save :set_username

private

  def set_username
    self.username = display_username.downcase
  end
end
