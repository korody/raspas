require 'test_helper'

class UserRegistrationTest < ActionDispatch::IntegrationTest
  test "register with invalid information" do
    get '/register'
    assert_response :success

    assert_no_difference 'User.count' do
      post_via_redirect '/register', user: { name: 'Nelson Muntz', email: 'nelson@muntz.com' }
    end

    assert_equal '/register', path
    refute session[:user_id]
  end

  test "register with valid information" do
    get '/register'
    assert_response :success

    assert_difference 'User.count' do
      post_via_redirect '/register', user: { name: 'Nelson Muntz', email: 'nelson@muntz.com', display_username: 'nmuntz', password: "nelSonM" }
    end

    assert_equal '/profile/nmuntz', path

    assert_not_nil session[:user_id]
    assert_equal User.last.id, session[:user_id]
  end
end
