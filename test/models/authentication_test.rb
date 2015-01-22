require 'test_helper'

class AuthenticationTest < ActiveSupport::TestCase
  should have_db_column(:id).of_type(:integer)
  should have_db_column(:user_id).of_type(:integer)
  should have_db_column(:provider).of_type(:string).with_options(null: false)
  should have_db_column(:uid).of_type(:string).with_options(null: false)
  should have_db_column(:info).of_type(:string)
  should have_db_column(:token).of_type(:string)
  should have_db_column(:secret).of_type(:string)
  should have_db_column(:expires).of_type(:boolean)
  should have_db_column(:expires_at).of_type(:datetime)
  should have_db_column(:extra).of_type(:string)

  should have_db_index(:user_id)
  should have_db_index([:provider, :uid]).unique(:true)

  should belong_to(:user)

  should validate_presence_of(:provider)
  should validate_presence_of(:uid)

  def setup
    @authentication = Authentication.new(provider: 'google', uid: '123456')
  end

  test "auth should be valid" do
    assert @authentication.valid?
  end
end
