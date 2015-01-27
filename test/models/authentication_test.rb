require 'test_helper'

class AuthenticationTest < ActiveSupport::TestCase
  should have_db_column(:id).of_type(:integer)
  should have_db_column(:user_id).of_type(:integer)
  should have_db_column(:provider).of_type(:string).with_options(null: false)
  should have_db_column(:uid).of_type(:string).with_options(null: false)
  should have_db_column(:info).of_type(:json)
  should have_db_column(:token).of_type(:string)
  should have_db_column(:secret).of_type(:string)
  should have_db_column(:expires).of_type(:boolean)
  should have_db_column(:expires_at).of_type(:datetime)
  should have_db_column(:extra).of_type(:json)
  should have_db_column(:access_token_digest).of_type(:string)

  should have_db_index(:user_id)
  should have_db_index([:provider, :uid]).unique(:true)

  should belong_to(:user)

  should validate_presence_of(:provider)
  should validate_presence_of(:uid)

  test "#acess_token" do
    assert_respond_to Authentication.new, :access_token
  end

  test ".from_omniauth sets access_token and acess_token_digest" do
    auth_params = {
      provider: 'google',
      uid: '987654',
      credentials: {
        token: 'abc',
        secret: 'secret',
        expires: true,
        expires_at: 1354920555
      },
      info: {
        name: 'Ned Flanders',
        email: 'ned@flanders.com',
        nickname: 'nflanders',
        image: 'path/to/image.jpg'
      },
      extra: {
        stuff: "Yay!"
      }
    }

    hash = OmniAuth::AuthHash.new(auth_params)
    auth = Authentication.from_omniauth(hash)

    assert_equal auth.provider, hash.provider
    assert_equal auth.uid, hash.uid

    assert_equal auth.token, hash.credentials.token
    assert_equal auth.secret, hash.credentials.secret
    assert_equal auth.expires, hash.credentials.expires
    assert_equal auth.expires_at, Time.at(hash.credentials.expires_at)

    assert_equal auth.info, hash.info
    assert_equal auth.extra, hash.extra

    assert_not_empty auth.access_token
    assert_not_empty auth.access_token_digest
  end

  test "includes Digest module" do
    assert_respond_to Authentication, :new_token
    assert_respond_to Authentication, :digest

    assert_respond_to Authentication.new, :authenticated?
  end
end
