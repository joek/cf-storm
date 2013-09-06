require_relative './acceptance_helper'

scope do
  test 'when a guest tries to access private content' do
    visit '/spaces/development/apps'
    assert page.find '#new-session'
  end

  test "a guest shouldn't see main menu" do
    visit '/'
    assert_raise Capybara::ElementNotFound do
      page.find '#nav-menu'
    end
  end

end
