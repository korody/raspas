require 'test_helper'

class RoutesTest < ActionController::TestCase
  should route(:get, '/profile/homer').to(controller: :users, action: :show, id: 'homer')
  should route(:get, '/profile/1').to(controller: :users, action: :show, id: 1)

  should route(:post, '/register').to(controller: :registrations, action: :create)
  should route(:get, '/register').to(controller: :registrations, action: :new)
end
