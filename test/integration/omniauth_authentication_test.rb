require 'test_helper'

class OmniauthAuthenticationTest < ActionDispatch::IntegrationTest
  def setup
    OmniAuth.config.test_mode = true
  end

  def teardown
    Authentication.delete_all
  end

  test "signup with valid information" do
    auth_params = {
      provider: 'google',
      uid: '987654',
      credentials: {
        token: 'abc'
      },
      info: {
        name: 'Ned Flanders',
        email: 'ned@flanders.com',
        nickname: 'nflanders',
        image: 'path/to/image.jpg'
      }
    }

    OmniAuth.config.mock_auth[:google] = OmniAuth::AuthHash.new(auth_params)

    get login_path
    assert_response :success

    assert_difference 'Authentication.count' do
      get_via_redirect '/auth/google'
    end

    assert_template 'authentications/new'

    user_params = {
      name: 'Elvis Presley',
      email: 'elvis@graceland.com',
      display_username: 'elvisthepelvis',
      password: 'rocking'
    }

    assert_difference 'User.count' do
      post_via_redirect '/authenticate', user: user_params
    end

    assert_not_nil session[:user_id]
    assert_equal User.last.id, session[:user_id]
    assert_template 'users/show'
    assert_equal profile_path, path
  end

  test "signup with invalid information" do
    auth_params = {
      provider: 'google',
      uid: '987654',
      credentials: {
        token: 'abc'
      },
      info: {
        name: 'Ned Flanders',
        email: 'ned@flanders.com',
        nickname: 'nflanders',
        image: 'path/to/image.jpg'
      }
    }

    OmniAuth.config.mock_auth[:google] = OmniAuth::AuthHash.new(auth_params)

    get login_path
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
    assert_template 'authentications/new'
    assert_equal authenticate_path, path
  end

  test "signup when nickname and image are not available" do
    auth_params = {
      provider: 'google',
      uid: '987654',
      credentials: {
        token: 'abc'
      },
      info: {
        name: 'Ned Flanders',
        email: 'ned@flanders.com',
      }
    }

    OmniAuth.config.mock_auth[:google] = OmniAuth::AuthHash.new(auth_params)

    get login_path
    assert_response :success

    assert_difference 'Authentication.count' do
      get_via_redirect '/auth/google'
    end
  end
end
