require 'test_helper'

class FriendlyForwardingTest < ActionDispatch::IntegrationTest
  test "forwards user to intended destination after logging in" do
    get '/profile/edit'

    assert_response :redirect
    assert_equal "http://www.example.com/profile/edit", session[:forwarding_url]

    user = users(:homer)

    post_via_redirect '/login', email_or_username: user.email, password: 'donuts'
    assert_equal '/profile/edit', path
    assert_template :edit
    assert_nil session[:forwarding_url]

    delete_via_redirect '/logout'
    assert_nil session[:user_id]
    assert_equal '/login', path

    post_via_redirect '/login', email_or_username: user.email, password: 'donuts'
    assert_equal '/profile', path
    assert_template :show
    assert_nil session[:forwarding_url]
  end
end
