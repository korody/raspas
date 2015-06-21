class Authentication < ActiveRecord::Base
  include TokenDigest

  attr_accessor :access_token

  validates :provider, :uid, presence: true

  belongs_to :user

  def self.from_omniauth(auth_hash)
    where(provider: auth_hash.provider, uid: auth_hash.uid).first_or_create do |new_auth|
      new_auth.info = auth_hash.info
      new_auth.extra = auth_hash.extra

      if auth_hash.credentials.present?
        new_auth.token = auth_hash.credentials.token
        new_auth.secret = auth_hash.credentials.secret
        new_auth.expires = auth_hash.credentials.expires

        if auth_hash.credentials.expires_at.present?
          new_auth.expires_at = Time.at(auth_hash.credentials.expires_at)
        end
      end

      new_auth.access_token = new_auth.class.new_token
      new_auth.access_token_digest = new_auth.class.digest(new_auth.access_token)
    end
  end
end
