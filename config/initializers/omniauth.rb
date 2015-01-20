OmniAuth.config.logger = Rails.logger
OmniAuth.config.on_failure = Proc.new { |env|
  OmniAuth::FailureEndpoint.new(env).redirect_to_failure
}
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, Rails.application.secrets.FACEBOOK_APP_ID, Rails.application.secrets.FACEBOOK_SECRET, 
    image_size: { height: 500, width: 500 }, display: 'popup'
  provider :google_oauth2, Rails.application.secrets.GOOGLE_CLIENT_ID, Rails.application.secrets.GOOGLE_CLIENT_SECRET,
    name: 'google', image_size: 500
end