require "test_helper"

class ApplicationHelperTest < ActionView::TestCase
  include ApplicationHelper

  test "#page_title" do
    assert_equal "COMPANYNAME Identity", page_title('')
    assert_equal "COMPANYNAME Identity - Nice Title", page_title("Nice Title")
  end
end
