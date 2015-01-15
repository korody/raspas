require 'test_helper'

class UsernameTest < ActiveSupport::TestCase
  valid_usernames = %w(pass 1pass pAss pa_ss pa1_sS pA_ss)
  invalid_usernames = %w(fail$ _fail fa%il fãil fa-il fa_il-)

  valid_usernames.each do |username|
    test "display_username #{username} should be valid" do
      assert_match Username::VALID_USERNAME_REGEX, username
    end
  end

  invalid_usernames.each do |username|
    test "display_username #{username} should not be valid" do
      assert_no_match Username::VALID_USERNAME_REGEX, username
    end
  end

  test "valid? returns true for valid username" do
    assert Username.valid?("milhouse")
  end

  test "valid? returns false for valid username" do
    refute Username.valid?("-milhouse")
  end
end
