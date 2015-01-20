class Authentication < ActiveRecord::Base
  validates :provider, :uid, presence: true

  belongs_to :user

  def self.with_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |authentication|
      authentication.provider = auth.provider
      authentication.uid = auth.uid
      authentication.info = auth.info
      authentication.token = auth.credentials.token
      authentication.secret = auth.credentials.secret
      authentication.expires = auth.credentials.expires
      authentication.expires_at = Time.at(auth.credentials.expires_at) unless auth.credentials.expires_at.nil?
      authentication.extra = auth.extra
    end
  end
end