module TokenDigest
  extend ActiveSupport::Concern

  def authenticated?(attribute, token)
    digest = send(attribute)
    BCrypt::Password.new(digest).is_password?(token)
  end

  class_methods do
    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end
end
