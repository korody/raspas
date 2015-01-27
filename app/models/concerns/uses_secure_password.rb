module UsesSecurePassword
  extend ActiveSupport::Concern

  included do
    include ActiveModel::SecurePassword
    include Concerns::Digest

    RESET_EXPIRATION = 2

    attr_accessor :remember_token, :confirmation_token, :reset_token
  end

  def remember
    self.remember_token = self.class.new_token
    update_attribute(:remember_digest, self.class.digest(remember_token))
  end

  def create_confirmation_digest
    self.confirmation_token = self.class.new_token
    self.confirmation_digest = self.class.digest(confirmation_token)
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  def confirm
    update_columns(confirmed: true, confirmed_at: Time.zone.now)
  end

  def create_reset_digest
    self.reset_token = self.class.new_token
    update_columns(reset_digest: self.class.digest(reset_token), reset_sent_at: Time.zone.now)
  end

  def reset_password(password)
    update(password: password, password_reset_token: nil, password_reset_sent_at: nil)
  end

  def reset_expired?
    reset_sent_at < RESET_EXPIRATION.hours.ago
  end

  def has_password?
    password_digest.present?
  end

  module ClassMethods
    def uses_secure_password(validate: true)
      has_secure_password validations: validate
    end

    def find_by_email_or_username(value)
      User.where("email = ? OR username = ?", value, value).first
    end
  end

  extend ClassMethods
end
