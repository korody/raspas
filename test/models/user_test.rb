require 'test_helper'

class UserTest < ActiveSupport::TestCase
  should have_db_column(:id).of_type(:integer)
  should have_db_column(:first_name).of_type(:string).with_options(null: false)
  should have_db_column(:last_name).of_type(:string).with_options(null: false)
  should have_db_column(:username).of_type(:string).with_options(null: false)
  should have_db_column(:display_username).of_type(:string).with_options(null: false)
  should have_db_column(:password_digest).of_type(:string)

  should have_db_index(:username).unique(true)
  should have_db_index(:display_username).unique(true)

  should have_many(:authentications)

  should validate_presence_of(:first_name)
  should ensure_length_of(:first_name).is_at_most(35)

  should validate_presence_of(:last_name)
  should ensure_length_of(:last_name).is_at_most(35)

  should validate_presence_of(:display_username)
  should ensure_length_of(:display_username).is_at_least(2).is_at_most(15)
  should validate_uniqueness_of(:display_username).case_insensitive

  should have_secure_password

  %w(pass 1pass pAss pa_ss pa1_sS pA_ss).each do |username|
    test "#{username} should be a valid username" do
      user = User.new(first_name: "Homer", last_name: "Simpson", display_username: username)
      assert user.valid?, "Username should be valid"
    end
  end

  %w(fail$ _fail fa%il fãil fa-il fa_il-).each do |username|
    test "#{username} should be a valid username" do
      user = User.new(first_name: "Homer", last_name: "Simpson", display_username: username)
      refute user.valid?, "Username should not be valid"
      assert_equal ["is invalid"], user.errors[:display_username]
    end
  end

  test "sets username to equal display_username in lowercase before save" do
    user = User.new(first_name: "Lisa", last_name: "Simpson", display_username: "Lisa")
    user.save and user.reload
    assert_equal "lisa", user.username
    assert_equal "Lisa", user.display_username
  end

  test "should not save without a password" do
  end
end
