class Authentication < ActiveRecord::Base
  validates :provider, :uid, presence: true

  belongs_to :user

  def self.create_from_omniauth(auth_hash)
    where(provider: auth_hash.provider, uid: auth_hash.uid).first_or_create do |new_auth|
      new_auth.provider = auth_hash.provider
      new_auth.uid  = auth_hash.uid
      new_auth.info = auth_hash.info
      new_auth.token = auth_hash.credentials.token
      new_auth.secret = auth_hash.credentials.secret
      new_auth.expires = auth_hash.credentials.expires
      new_auth.expires_at = Time.at(auth_hash.credentials.expires_at) if auth_hash.credentials.expires_at.present?
      new_auth.extra = auth_hash.extra
    end
  end
end
