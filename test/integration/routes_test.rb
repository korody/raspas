require 'test_helper'

class RoutesTest < ActionController::TestCase
  should route(:get, '/profile').to(controller: :users, action: :show)

  should route(:post, '/register').to(controller: :registrations, action: :create)
  should route(:get, '/register').to(controller: :registrations, action: :new)
end
