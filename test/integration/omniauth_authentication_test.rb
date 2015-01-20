require 'test_helper'

class OmniauthAuthenticationTest < ActionDispatch::IntegrationTest

  setup do
    OmniAuth.config.add_mock(:google, {
      uid: '12345',
      credentials: {
        token: '12345'
      },
      extra: {
        raw_info: {
          image: 'path/to/image'
        }
      }
    })
  end

  test "signup with valid information" do
    get '/login'
    assert_response :success
    get_via_redirect '/auth/google'

    assert_not_nil session[:user_id]
    assert_equal User.last.id, session[:user_id]
  end

  teardown do
    OmniAuth.config.mock_auth[:google] = nil
  end
end
