require 'test_helper'

class OmniauthAuthenticationTest < ActionDispatch::IntegrationTest

  def setup
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

  def teardown
    OmniAuth.config.mock_auth[:google] = nil
  end

  test "signup with valid information" do
    get '/login'
    assert_response :success
    get_via_redirect '/auth/google'
    assert_template 'registrations/new'
#     assert_not_nil session[:user_id]
#     assert_equal User.last.id, session[:user_id]
  end
end
