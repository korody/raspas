require 'test_helper'

class LogoutTest < ActionDispatch::IntegrationTest
  test "log out" do
    login(:homer)
    delete '/logout'

    assert_response :redirect
    assert_redirected_to login_path

    follow_redirect!

    assert_nil session[:user_id]
    assert_equal login_path, path
    assert_template 'sessions/new'
  end
end
