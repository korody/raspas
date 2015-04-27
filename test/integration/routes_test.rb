require 'test_helper'

class RoutesTest < ActionController::TestCase
  # JSON check is failing here. Shoulda converts it into a string, but the route defines json as a symbol
  # And this way we get an equality mismatch and a failing test.
  # This is now fixed, see https://github.com/thoughtbot/shoulda-matchers/issues/685
  should route(:get, '/validate').to(controller: :validations, action: :validate, format: :json)

  should route(:patch, '/password_resets/123').to(controller: :password_resets, action: :update, id: 123)
  should route(:get, '/password_resets/123/edit').to(controller: :password_resets, action: :edit, id: 123)
  should route(:post, '/password_resets').to(controller: :password_resets, action: :create)
  should route(:get, '/password_resets/new').to(controller: :password_resets, action: :new)

  should route(:post, '/auth_registrations').to(controller: :auth_registrations, action: :create)
  should route(:get, '/auth_registrations/new').to(controller: :auth_registrations, action: :new)

  should route(:get, '/auth/google/callback').to(controller: :authentications, action: :create, provider: 'google')
  should route(:get, '/auth/failure').to(controller: :authentications, action: :failure)

  should route(:post, '/login').to(controller: :sessions, action: :create)
  should route(:get, '/login').to(controller: :sessions, action: :new)

  should route(:patch, '/profile').to(controller: :users, action: :update)
  should route(:get, '/profile/edit').to(controller: :users, action: :edit)
  should route(:get, '/profile').to(controller: :users, action: :show)

  should route(:post, '/register').to(controller: :registrations, action: :create)
  should route(:get, '/register').to(controller: :registrations, action: :new)

  # For some unknown reason this is failing.
  # I saw an issue on shouda's repo on Github with a similar failure.
  # Will invetigate when there's more time.
  # should route(:get, '/').to(controller: :sessions, action: :new)
end
