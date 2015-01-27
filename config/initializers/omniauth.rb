OmniAuth.config.logger = Rails.logger

OmniAuth.config.on_failure = Proc.new { |env|
  OmniAuth::FailureEndpoint.new(env).redirect_to_failure
}

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, secret(:FACEBOOK_APP_ID), secret(:FACEBOOK_SECRET), image_size: {
    height: 500,
    width: 500
  }

  provider :google_oauth2, secret(:GOOGLE_CLIENT_ID), secret(:GOOGLE_CLIENT_SECRET), name: 'google', image_size: 500

  provider :twitter, secret(:TWITTER_API_KEY), secret(:TWITTER_API_SECRET)
end

def secret(key)
  Rails.application.secrets.send(key)
end
