require 'test_helper'

class UserUpdatesAccountTest < ActionDispatch::IntegrationTest
  def setup
    @user = login(:homer)
  end

  test "user updates account with valid information" do
    patch_via_redirect '/profile', user: { name: 'Bart Simpson' }

    assert_response :success
    assert_equal '/profile', path
    assert_equal 'Bart Simpson', @user.reload.name
  end

  test "user updates account with invalid information" do
    patch_via_redirect '/profile', user: { name: '' }

    assert_response :success
    assert_template :edit
    assert_equal 'Homer Simpson', @user.reload.name
  end

private

  def login(user)
    user = users(user)
    post_via_redirect '/login', username: user.username, password: 'donuts'

    assert_not_nil session[:user_id]
    assert_equal user.id, session[:user_id]

    go_to '/profile/edit', template: :edit
    user
  end
end
