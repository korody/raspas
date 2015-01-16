require 'test_helper'

class RegistrationsControllerTest < ActionController::TestCase
  test "should get new" do
    get :new
    assert_response :success
    assert_not_nil assigns(:user)
    assert_template :new
  end

  test "does not create user with invalid data" do
    assert_no_difference 'User.count' do
      post :create, user: { name: "Marg" }
    end
    assert_response :success
    assert_not_nil assigns(:user)
    assert_template :new
  end

  test "creates user with valid info" do
    assert_difference 'User.count' do
      post :create, user: { name: 'Marg Simspon', email: 'marg@simpson.com', display_username: 'marg', password: '123456' }
    end
    # This may need to be changed once we decide what is happening
    assert_redirected_to user_path(User.last)
  end
end
