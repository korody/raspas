require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  def setup
    @user = users(:homer)
  end

  test "get #show when not signed in" do
    get :show

    assert_response :redirect
    assert_nil assigns(:user)
    assert_redirected_to login_path
  end

  test "get show when signed in" do
    get :show, {}, user_id: @user.id

    assert_response :success
    assert_not_nil assigns(:user)
    assert_template :show
  end

  test "get edit when not signed in" do
    get :edit

    assert_response :redirect
    assert_nil assigns(:user)
    assert_redirected_to login_path
  end

  test "get edit when signed in" do
    get :edit, {}, user_id: @user.id

    assert_response :success
    assert_not_nil assigns(:user)
    assert_template :edit
  end
end

