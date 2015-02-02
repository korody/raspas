require 'test_helper'

class EmailAddressTest < ActiveSupport::TestCase
  valid_emails = ['homer@simp.sp', '_BART_@simp.com', 'lisa.simp@spring.field.com', 'marg+simp@spring.field']
  invalid_emails = ['homer@simp', '_BART_@ simp.com', 'lisa.simp.field.com', '@spring.com', 'lisa@', 'ba rt@simp.com']

  valid_emails.each do |email|
    test "email #{email} should be valid" do
      assert_match EmailAddress::VALID_EMAIL_ADDRESS_REGEX, email
    end
  end

  invalid_emails.each do |email|
    test "email #{email} should not be valid" do
      assert_no_match EmailAddress::VALID_EMAIL_ADDRESS_REGEX, email
    end
  end

  test ".valid? returns true for valid email" do
    assert EmailAddress.valid?("milhouse@springville.com")
  end

  test ".valid? returns false for invalid email" do
    refute EmailAddress.valid?("milhouse@springville")
  end

  test ".malformed? returns false for valid email" do
    refute EmailAddress.malformed?("milhouse@springville.com")
  end

  test ".malformed? returns true for invalid email" do
    assert EmailAddress.malformed?("milhouse@springville")
  end
end
