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

    assert_difference 'Authentication.count' do
      get_via_redirect '/auth/google'
    end

    assert_template 'authentications/new'

    assert_difference 'User.count' do
      post_via_redirect '/authenticate', user: {
        name: 'Elvis Presley', email: 'elvis@graceland.com', display_username: 'elvisthepelvis', password: "rocking"
      }
    end

    assert_not_nil session[:user_id]
    assert_equal User.last.id, session[:user_id]
  end

  test "signup with invalid information" do
    get '/login'
    assert_response :success

    assert_difference 'Authentication.count' do
      get_via_redirect '/auth/google'
    end

    assert_template 'authentications/new'

    assert_no_difference 'User.count' do
      post_via_redirect '/authenticate', user: { name: 'Elvis Presley', email: 'elvis@graceland.com' }
    end

    assert_equal '/authenticate', path
    assert_nil session[:user_id]
  end
end
