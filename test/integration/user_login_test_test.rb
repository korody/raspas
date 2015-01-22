require 'test_helper'

class UserLoginTestTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:homer)
  end

  test "user should login with valid email and password" do
    go_to_login
    post_via_redirect '/login', email_or_username: @user.email, password: 'donuts'

    assert_equal '/profile', path
    assert_not_nil session[:user_id]
    assert_equal @user.id, session[:user_id]
  end

  test "user should login with valid username and password" do
    go_to_login
    post_via_redirect '/login', email_or_username: @user.username, password: 'donuts'

    assert_equal '/profile', path
    assert_not_nil session[:user_id]
    assert_equal @user.id, session[:user_id]
  end

  test "user should not login with a bad password" do
    go_to_login
    post_via_redirect '/login', email_or_username: @user.username, password: 'bad password'

    assert_equal '/login', path
    assert_nil session[:user_id]
  end

  test "user should not login with a bad username or email" do
    go_to_login
    post_via_redirect '/login', email_or_username: 'bad@email.com', password: 'donuts'

    assert_equal '/login', path
    assert_nil session[:user_id]
  end

  test "user should not login while already logged in" do
    user = login(:homer)
    get_via_redirect '/login'

    assert_response :success
    assert_equal '/profile', path
    assert_template 'users/show'
  end

  test "user should log out" do
    login(:homer)
    delete_via_redirect '/logout'

    assert_nil session[:user_id]
    assert_equal '/login', path
    assert_template 'sessions/new'
  end

  test "user should log in with correct email or username with extra whitespace" do
    go_to_login
    post_via_redirect '/login', email_or_username: " #{@user.email} ", password: 'donuts'

    assert_equal '/profile', path
    assert_not_nil session[:user_id]
    assert_equal @user.id, session[:user_id]    
  end

  test "user should log in with correct email or username in uppercase" do
    go_to_login
    post_via_redirect '/login', email_or_username: @user.username.upcase, password: 'donuts'

    assert_equal '/profile', path
    assert_not_nil session[:user_id]
    assert_equal @user.id, session[:user_id]    
  end

private

  def go_to_login
    go_to '/login', template: 'sessions/new'
    assert_nil session[:user_id]
  end
end
