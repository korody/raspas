require 'test_helper'

class AuthenticationTest < ActiveSupport::TestCase
  should have_db_column(:id).of_type(:integer)
  should have_db_column(:user_id).of_type(:integer).with_options(null: false)
  should have_db_column(:provider).of_type(:string).with_options(null: false)
  should have_db_column(:uid).of_type(:string).with_options(null: false)

  should have_db_index(:user_id)
  should have_db_index([:provider, :uid]).unique(:true)

  should belong_to(:user)
end
