require 'test_helper'

class UserTest < ActiveSupport::TestCase
  should have_db_column(:id).of_type(:integer)
  should have_db_column(:name).of_type(:string).with_options(null: false)
  should have_db_column(:email).of_type(:string).with_options(null: false)
  should have_db_column(:username).of_type(:string).with_options(null: false)
  should have_db_column(:display_username).of_type(:string).with_options(null: false)
  should have_db_column(:image).of_type(:string)
  should have_db_column(:password_digest).of_type(:string)

  should have_db_column(:remember_digest).of_type(:string)

  should have_db_column(:reset_digest).of_type(:string)
  should have_db_column(:reset_sent_at).of_type(:string)

  should have_db_index(:email).unique(true)
  should have_db_index(:username).unique(true)
  should have_db_index(:display_username).unique(true)

  should have_many(:authentications)

  should validate_presence_of(:name)
  should ensure_length_of(:name).is_at_most(60)

  should validate_presence_of(:email)
  should ensure_length_of(:email).is_at_most(60)
  should validate_uniqueness_of(:email).case_insensitive
  should allow_value('homer@simp.sp', '_BART_@simp.com', 'lisa.simp@spring.field.com', 'marg+simp@spring.field').for(:email)
  should_not allow_value('homer@simp', '_BART_@ simp.com', 'lisa.simp.field.com', '@spring.com', 'lisa@', 'ba rt@simp.com').for(:email)

  should validate_presence_of(:display_username)
  should ensure_length_of(:display_username).is_at_least(2).is_at_most(15)
  should validate_uniqueness_of(:display_username).case_insensitive
  should allow_value('pass', '1pass', 'pAss', 'pa_ss', 'pa1_sS', 'pA_ss').for(:display_username)
  should_not allow_value('fail$', '_fail', 'fa%il', 'fãil', 'fa-il', 'fa_il-', 'fa il').for(:display_username)

  should have_secure_password

  test "sets username to equal display_username in lowercase before save" do
    homer = users(:homer)
    homer.display_username = 'hOmEr'
    homer.save
    assert_equal 'homer', homer.reload.username
    assert_equal 'hOmEr', homer.display_username
  end

  test "downcases email" do
    homer = users(:homer)
    homer.email = 'HOMER@SIMPSON.COM'
    homer.save
    assert_equal 'homer@simpson.com', homer.reload.email
  end

  test "#add_auth" do
    skip
  end

  test "#to_param" do
    skip
  end

  test ".initialize_from_auth" do
    skip
  end
end
