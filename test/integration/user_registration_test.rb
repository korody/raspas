require 'test_helper'

class UserRegistrationTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries = []
  end

  test "user should not register with bad information" do
    go_to '/register', template: 'registrations/new'

    assert_no_difference 'User.count' do
      post_via_redirect '/register', user: { name: 'Nelson Muntz', email: 'nelson@muntz.com' }
    end

    assert_equal '/register', path
    assert_nil session[:user_id]

    assert ActionMailer::Base.deliveries.empty?, "Email should not be sent."
  end

  test "use should register with valid information" do
    go_to '/register', template: 'registrations/new'

    assert_difference 'User.count' do
      post_via_redirect '/register', user: { name: 'Nelson Muntz', email: 'nelson@muntz.com', display_username: 'nmuntz', password: "nelSonM" }
    end

    assert_equal '/profile', path
    assert_not_nil session[:user_id]
    assert_equal User.last.id, session[:user_id]

    assert_not ActionMailer::Base.deliveries.empty?
    assert_equal 1, ActionMailer::Base.deliveries.size
  end
end
