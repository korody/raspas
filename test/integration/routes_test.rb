require 'test_helper'

class RoutesTest < ActionController::TestCase
  should route(:get, 'auth/google/callback').to(controller: :authentications, action: :create, provider: 'google')
  should route(:get, '/auth/failure').to(controller: :authentications, action: :failure)

  should route(:get, '/login').to(controller: :authentications, action: :new)
  should route(:post, '/login').to(controller: :authentications, action: :create)

  should route(:get, '/profile/homer').to(controller: :users, action: :show, id: 'homer')
  should route(:get, '/profile/1').to(controller: :users, action: :show, id: 1)

  should route(:post, '/register').to(controller: :registrations, action: :create)
  should route(:get, '/register').to(controller: :registrations, action: :new)
end
