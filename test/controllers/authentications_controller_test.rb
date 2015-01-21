require 'test_helper'

class AuthenticationsControllerTest < ActionController::TestCase
  test "should get failure" do
    get :failure
    assert_response :redirect
  end

  test "should logout" do
    post :destroy
    assert_response :redirect
    assert_nil assigns(:user)
  end
end