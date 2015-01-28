require 'test_helper'

class PasswordResetEditTest < ActionDispatch::IntegrationTest
  # We are testing the password update functionality here.
  # For this to happen, we must ensure the user makes a valid request to update the password.
  # The setup phase ensures the user is loaded, visits the password reset form, makes a request,
  # and gets assigned a reset token (virtual attribute) that we need to keep a hold off before
  # it disappears in the redirected.
  # We're testing the edit and update actions of the password resets controller.
  def setup
    user = users(:homer)

    go_to new_password_reset_path, template: 'password_resets/new'
    post password_resets_path, email_or_username: user.email

    @user = assigns(:user)
    follow_redirect!

    assert_not_nil @user.reset_token
  end

  def teardown
    ActionMailer::Base.deliveries.clear
  end

  test "edit password with valid email and token" do
    get edit_password_reset_path(@user.reset_token), email: @user.email

    assert_response :success
    assert_template 'password_resets/edit'
    assert_equal edit_password_reset_path(@user.reset_token), path

    # Update password with bad one
    params = { email: @user.email, user: { password: 'short' } }
    patch_via_redirect password_reset_path, params

    assert_equal password_reset_path, path
    assert_not_empty flash[:danger]

    # Update password
    params = { email: @user.email, user: { password: 'new password' } }
    patch_via_redirect password_reset_path, params

    # User should be updated and redirected to login path
    assert_equal login_path, path
    assert_template 'sessions/new'

    # Make sure user is not signed in
    assert_nil session[:user_id]

    # Login with new password
    post_via_redirect login_path, email_or_username: @user.email, password: 'new password'

    # Make sure user is signed in
    assert_equal profile_path, path
    assert_template 'users/show'
    assert_not_nil session[:user_id]
    assert_equal @user.id, session[:user_id]
  end

  test "edit password with invalid email" do
    get edit_password_reset_path(@user.reset_token), email: 'wrong email'
    assert_redirected_to_new_password_reset_path
  end

  test "edit password with invalid token" do
    get edit_password_reset_path('abcdef'), email: @user.email
    assert_redirected_to_new_password_reset_path
  end

  test "edit password with expired token" do
    @user.update(reset_sent_at: 3.hours.ago)
    get edit_password_reset_path(@user.reset_token), email: @user.email
    assert_redirected_to_new_password_reset_path
  end

  test "patch request with invalid email" do
    patch password_reset_path(@user.reset_token), email: 'wrong email'
    assert_redirected_to_new_password_reset_path
  end

  test "patch request with invalid token" do
    patch password_reset_path('abcde'), email: @user.email
    assert_redirected_to_new_password_reset_path
  end

  test "patch request with expired token" do
    @user.update(reset_sent_at: 3.hours.ago)
    patch password_reset_path(@user.reset_token), email: @user.email
    assert_redirected_to_new_password_reset_path
  end

private

  def assert_redirected_to_new_password_reset_path
    assert_response :redirect
    assert_redirected_to new_password_reset_path

    follow_redirect!

    assert_equal new_password_reset_path, path
    assert_template 'password_resets/new'
    assert_nil session[:user_id]
  end
end
