require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:homer)
  end

  test "requesting a password reset while signed in should redirect to profile page" do
    user = login(:homer)
    get_via_redirect '/password_reset'

    assert_equal '/profile', path
  end

  test "requesting a password reset with valid email should process request" do
    go_to '/password_reset', template: 'password_resets/new'

    assert_nil @user.reset_digest
    assert_nil @user.reset_sent_at

    post_via_redirect '/password_reset', email_or_username: @user.email
    @user.reload

    assert_not_nil @user.reset_digest
    assert_not_nil @user.reset_sent_at
  end

  test "requesting a password reset with invalid email should not process request" do
    go_to '/password_reset', template: 'password_resets/new'
    post_via_redirect '/password_reset', email_or_username: 'invalid@email.com'

    assert_template 'password_resets/new'
    assert_equal '/password_reset', path
  end

  test "requesting a password reset with valid username should process request" do
    go_to '/password_reset', template: 'password_resets/new'

    assert_nil @user.reset_digest
    assert_nil @user.reset_sent_at

    post_via_redirect '/password_reset', email_or_username: @user.username
    @user.reload

    assert_not_nil @user.reset_digest
    assert_not_nil @user.reset_sent_at
  end

  test "requesting a password reset with invalid username should not process request" do
    go_to '/password_reset', template: 'password_resets/new'
    post_via_redirect '/password_reset', email_or_username: 'invalid'

    assert_template 'password_resets/new'
    assert_equal '/password_reset', path
  end

  test "requesting a password reset with correct email or username with additional whitespace should process request" do
    go_to '/password_reset', template: 'password_resets/new'

    assert_nil @user.reset_digest
    assert_nil @user.reset_sent_at

    post_via_redirect '/password_reset', email_or_username: " #{@user.username} "
    @user.reload

    assert_not_nil @user.reset_digest
    assert_not_nil @user.reset_sent_at
  end

  test "requesting a password reset with correct email or username in uppercase should process request" do
    go_to '/password_reset', template: 'password_resets/new'

    assert_nil @user.reset_digest
    assert_nil @user.reset_sent_at

    post_via_redirect '/password_reset', email_or_username: @user.username.upcase
    @user.reload

    assert_not_nil @user.reset_digest
    assert_not_nil @user.reset_sent_at
  end
end
