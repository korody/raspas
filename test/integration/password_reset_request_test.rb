require 'test_helper'

class PasswordResetRequestTest < ActionDispatch::IntegrationTest
  # This tests the generation of a password reset and sending of the email.
  # To setup these tests we need a user to visit the new_password_reset_path,
  # and to be sure its not signed in.
  # We're testing the new and create actions of the password resets controller.
  def setup
    @user = users(:homer)

    go_to new_password_reset_path, template: 'password_resets/new'

    assert_nil @user.reset_digest
    assert_nil @user.reset_sent_at
  end

  def teardown
    @user = nil
  end

  test "requesting a password reset while signed in should redirect to profile page" do
    user = login(:homer)
    get new_password_reset_path

    assert_response :redirect
    assert_redirected_to profile_path
    follow_redirect!
    assert_equal profile_path, path
  end

  test "password reset with valid email" do
    post password_resets_path, email_or_username: @user.email
    assert_reset_request_processed
  end

  test "password reset request valid username" do
    post password_resets_path, email_or_username: @user.username
    assert_reset_request_processed
  end

  test "password reset request email or username and whitespace" do
    post password_resets_path, email_or_username: " #{@user.username} "
    assert_reset_request_processed
  end

  test "password reset request email or username in uppercase" do
    post password_resets_path, email_or_username: @user.username.upcase
    assert_reset_request_processed
  end

  test "password reset request with invalid email" do
    go_to new_password_reset_path, template: 'password_resets/new'
    post password_resets_path, email_or_username: 'invalid@email.com'

    assert_template 'password_resets/new'
    assert_equal password_resets_path, path
  end

  test "password reset request with invalid username" do
    go_to new_password_reset_path, template: 'password_resets/new'
    post password_resets_path, email_or_username: 'invalid'

    assert_template 'password_resets/new'
    assert_equal password_resets_path, path
  end

private

  def assert_reset_request_processed
    assert_response :redirect
    assert_redirected_to login_path

    follow_redirect!

    assert_template 'sessions/new'
    assert_equal login_path, path

    @user.reload

    assert_not_nil @user.reset_digest
    assert_not_nil @user.reset_sent_at
  end
end
