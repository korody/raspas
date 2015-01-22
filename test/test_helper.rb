ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  OmniAuth.config.test_mode = true

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  def go_to(path, template: false)
    get path
    assert_response :success
    assert_template template if template
  end

  def login(user)
    user = users(user)
    post_via_redirect '/login', email_or_username: user.username, password: 'donuts'

    assert_not_nil session[:user_id]
    assert_equal user.id, session[:user_id]

    user
  end
end
