require 'test_helper'

class AuthRegistrationsTest < ActionDispatch::IntegrationTest
  def setup
    OmniAuth.config.test_mode = true
  end

  test "user registers with valid information via OmniAuth" do
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

    auth = assigns(:auth)
    assert_not_nil auth

    user_params = {
      name: 'Ned Flanders',
      email: 'ned@flanders.com',
      display_username: 'nflanders',
      password: 'ohgodohgod'
    }

    assert_difference 'User.count' do
      post_via_redirect auth_registrations_path, user: user_params, auth_id: @request.params[:auth_id], access_token: @request.params[:access_token]
    end

    assert_not_nil session[:user_id]
    assert_equal User.last.id, session[:user_id]
    assert_template 'users/show'
    assert_equal profile_path, path
  end


  test "user registers with invalid information via OmniAuth" do
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

    auth = assigns(:auth)
    assert_not_nil auth

    user_params = {
      email: 'ned@flanders.com',
      display_username: 'nflanders',
      password: 'ohgodohgod'
    }

    assert_no_difference 'User.count' do
      post_via_redirect auth_registrations_path, user: user_params, auth_id: @request.params[:auth_id], access_token: @request.params[:access_token]
    end

    assert_not_nil @request.params[:access_token]
    assert_not_nil @request.params[:auth_id]

    assert_nil session[:user_id]
    assert_template 'auth_registrations/new'
    assert_equal auth_registrations_path, path
  end

  test "user attempts registration with invalid auth_id" do
    assert_raises ActiveRecord::RecordNotFound do
      get new_auth_registration_path(auth_id: 1, access_token: '1234')
    end
  end

  test "user attempts registration with invalid token" do
    assert_raises BCrypt::Errors::InvalidHash do
      get new_auth_registration_path(auth_id: Authentication.last.id, access_token: 'hello')
    end
  end

  test "user attempts registration without auth_id" do
    get new_auth_registration_path(access_token: '1')
    assert_response :redirect
    assert_redirected_to login_path
    follow_redirect!
    assert_equal login_path, path
  end

  test "user attempts registration without token" do
    get new_auth_registration_path(auth_id: '1')
    assert_response :redirect
    assert_redirected_to login_path
    follow_redirect!
    assert_equal login_path, path
  end
end
