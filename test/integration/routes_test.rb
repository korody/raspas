require 'test_helper'

class RoutesTest < ActionController::TestCase
  should route(:get, '/auth/google/callback').to(controller: :authentications, action: :create, provider: 'google')
  should route(:get, '/auth/failure').to(controller: :authentications, action: :failure)

  should route(:post, '/login').to(controller: :sessions, action: :create)
  should route(:get, '/login').to(controller: :sessions, action: :new)

  should route(:patch, '/profile').to(controller: :users, action: :update)
  should route(:get, '/profile/edit').to(controller: :users, action: :edit)
  should route(:get, '/profile').to(controller: :users, action: :show)

  should route(:post, '/register').to(controller: :registrations, action: :create)
  should route(:get, '/register').to(controller: :registrations, action: :new)

  should route(:get, '/').to(controller: :sessions, action: :new)
end
