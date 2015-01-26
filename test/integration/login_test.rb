require 'test_helper'

class LoginTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:homer)
  end

  test "login with valid email and password" do
    go_to_login
    post_via_redirect login_path, email_or_username: @user.email, password: 'donuts'

    assert_equal profile_path, path
    assert_not_nil session[:user_id]
    assert_equal @user.id, session[:user_id]
  end

  test "login with valid username and password" do
    go_to_login
    post_via_redirect login_path, email_or_username: @user.username, password: 'donuts'

    assert_equal profile_path, path
    assert_not_nil session[:user_id]
    assert_equal @user.id, session[:user_id]
  end

  test "login with a bad password" do
    go_to_login
    post_via_redirect login_path, email_or_username: @user.username, password: 'bad password'

    assert_equal login_path, path
    assert_nil session[:user_id]
  end

  test "login with a bad username or email" do
    go_to_login
    post_via_redirect login_path, email_or_username: 'bad@email.com', password: 'donuts'

    assert_equal login_path, path
    assert_nil session[:user_id]
  end

  test "login while already logged in" do
    user = login(:homer)
    get_via_redirect login_path

    assert_response :success
    assert_equal profile_path, path
    assert_template 'users/show'
  end

  test "login with correct email or username and whitespace" do
    go_to_login
    post_via_redirect login_path, email_or_username: " #{@user.email} ", password: 'donuts'

    assert_equal profile_path, path
    assert_not_nil session[:user_id]
    assert_equal @user.id, session[:user_id]    
  end

  test "login with correct email or username in uppercase" do
    go_to_login
    post_via_redirect login_path, email_or_username: @user.username.upcase, password: 'donuts'

    assert_equal profile_path, path
    assert_not_nil session[:user_id]
    assert_equal @user.id, session[:user_id]    
  end

private

  def go_to_login
    go_to login_path, template: 'sessions/new'
    assert_nil session[:user_id]
  end
end
