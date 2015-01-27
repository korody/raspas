require 'test_helper'

class OmniauthAuthenticationTest < ActionDispatch::IntegrationTest
  def setup
    OmniAuth.config.test_mode = true
  end

  test "when logged in, authenticate with new provider" do
    user = users(:homer)
    auth = user.authentications.last.attributes.except(:id)

    OmniAuth.config.mock_auth[:google] = OmniAuth::AuthHash.new(auth)

    assert_no_difference 'Authentication.count' do
      get_via_redirect '/auth/google'
    end

    assert_not_nil session[:user_id]
    assert_equal user.id, session[:user_id]
    assert_equal profile_path, path

    auth_params = {
      provider: 'twitter',
      uid: '123456',
      info: {
        email: user.email,
        nickname: user.username,
      }
    }

    OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new(auth_params)

    assert_difference 'Authentication.count' do
      get_via_redirect '/auth/twitter'
    end

    assert_includes user.authentications, Authentication.last

    assert_not_nil session[:user_id]
    assert_equal user.id, session[:user_id]
    assert_equal profile_path, path
  end

  test "when logged in, authenticate with same provider" do
    user = users(:homer)
    auth = user.authentications.last.attributes.except(:id)

    OmniAuth.config.mock_auth[:google] = OmniAuth::AuthHash.new(auth)

    assert_no_difference 'Authentication.count' do
      get_via_redirect '/auth/google'
    end

    assert_not_nil session[:user_id]
    assert_equal user.id, session[:user_id]
    assert_equal profile_path, path

    assert_no_difference 'Authentication.count' do
      get_via_redirect '/auth/google'
    end

    assert_not_nil session[:user_id]
    assert_equal user.id, session[:user_id]
    assert_equal profile_path, path
  end

  test "when not logged in, authenticate with existing provider" do
    user = users(:homer)
    auth = user.authentications.last.attributes.except(:id)

    OmniAuth.config.mock_auth[:google] = OmniAuth::AuthHash.new(auth)

    get login_path
    assert_nil session[:user_id]

    assert_no_difference 'Authentication.count' do
      get_via_redirect '/auth/google'
    end

    assert_not_nil session[:user_id]
    assert_equal user.id, session[:user_id]
    assert_equal profile_path, path
  end

  test "when not logged in, authenticate with new provider" do
    user = users(:homer)

    auth_params = {
      provider: 'twitter',
      uid: '123456',
      info: {
        email: user.email,
        nickname: user.username,
      }
    }

    OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new(auth_params)

    get login_path
    assert_nil session[:user_id]

    assert_difference 'Authentication.count' do
      get_via_redirect '/auth/twitter'
    end

    assert_not_nil session[:user_id]
    assert_equal user.id, session[:user_id]
    assert_equal profile_path, path
  end

  test "when not logged in, authenticate with new provider and no prior accounts" do
    auth_params = {
      provider: 'google',
      uid: '987654',
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

    assert_not_nil @request.params[:access_token]
    assert_not_nil @request.params[:auth_id]

    assert_template 'auth_registrations/new'
    assert_equal new_auth_registration_path, path
  end

  test "simulate failure" do
    OmniAuth.config.mock_auth[:google] = :invalid_credentials

    get login_path
    assert_response :success

    assert_no_difference 'Authentication.count' do
      get_via_redirect '/auth/google'
    end

    assert_equal register_path, path
    assert_nil session[:user_id]
  end
end
