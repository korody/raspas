require 'test_helper'

class UserLoginTestTest < ActionDispatch::IntegrationTest
  def setup
    @user = User.create(name: 'Monty Burns', email: 'monty@burns.com', display_username: 'mrburns', password: 'Excellent')
  end

  def teardown
    @user = nil
  end

  test "user logs in with email" do
    get '/login'
    assert_response :success
    assert_nil session[:user_id]

    post_via_redirect '/login', username: @user.email, password: @user.password

    assert_equal '/profile', path
    assert_not_nil session[:user_id]
    assert_equal @user.id, session[:user_id]
  end

  test "user logs in with username" do
    get '/login'
    assert_response :success
    assert_nil session[:user_id]

    post_via_redirect '/login', username: @user.username, password: @user.password

    assert_equal '/profile', path
    assert_not_nil session[:user_id]
    assert_equal @user.id, session[:user_id]
  end

  test "user logs in with invalid credentials" do
    get '/login'
    assert_response :success
    assert_nil session[:user_id]

    post_via_redirect '/login', username: @user.username, password: 'wrong password'

    assert_equal '/login', path
    assert_nil session[:user_id]
  end
end
