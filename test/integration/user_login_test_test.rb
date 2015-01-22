require 'test_helper'

class UserLoginTestTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:homer)
  end

  test "user logs in with email" do
    go_to_login
    post_via_redirect '/login', email_or_username: @user.email, password: 'donuts'

    assert_equal '/profile', path
    assert_not_nil session[:user_id]
    assert_equal @user.id, session[:user_id]
  end

  test "user logs in with username" do
    go_to_login
    post_via_redirect '/login', email_or_username: @user.username, password: 'donuts'

    assert_equal '/profile', path
    assert_not_nil session[:user_id]
    assert_equal @user.id, session[:user_id]
  end

  test "user logs in with bad password" do
    go_to_login
    post_via_redirect '/login', email_or_username: @user.username, password: 'bad password'

    assert_equal '/login', path
    assert_nil session[:user_id]
  end

  test "user logs in with bad email or username" do
    go_to_login
    post_via_redirect '/login', email_or_username: 'bad@email.com', password: @user.password

    assert_equal '/login', path
    assert_nil session[:user_id]
  end

  test "user tries to login while logged in" do
    user = login(:homer)

    get '/login'
    follow_redirect!

    assert_response :success
    assert_equal '/profile', path
    assert_template :show
  end

  test "user logs out" do
    login(:homer)
    delete_via_redirect '/logout'

    assert_nil session[:user_id]
    assert_equal '/login', path
    assert_template :new
  end

private

  def go_to_login
    go_to '/login'
    assert_nil session[:user_id]
  end
end
