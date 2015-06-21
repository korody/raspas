module UsesSecurePassword
  extend ActiveSupport::Concern
  include TokenDigest

  included do
    include ActiveModel::SecurePassword

    RESET_EXPIRATION = 2

    attr_accessor :remember_token, :reset_token, :resetting_password
  end

  class_methods do
    def uses_secure_password(validate: true)
      has_secure_password validations: validate
    end

    def find_by_login(login)
      User.where("email = :login OR username = :login", login: login).first
    end
  end

  def remember
    self.remember_token = self.class.new_token
    update_attribute(:remember_digest, self.class.digest(remember_token))
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  def create_reset_digest
    self.reset_token = self.class.new_token
    update_columns(reset_digest: self.class.digest(reset_token), reset_sent_at: Time.zone.now)
  end

  def reset_password(password)
    self.resetting_password = true
    update(password: password, reset_digest: nil, reset_sent_at: nil)
  end

  def reset_expired?
    reset_sent_at < RESET_EXPIRATION.hours.ago
  end

  def has_password?
    password_digest.present?
  end

  def validate_password?
    new_record? || password_digest_changed? || resetting_password
  end
end
