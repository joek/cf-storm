require_relative './acceptance_helper'

scope do

  test 'Given I logged in when there are some apps into the development space' do
    login_user!
    visit '/spaces/development/apps'

    assert has_content? "development applications"

    # within('#apps-list') do
    #   assert has_content? "Windows 8"
    # end
  end

end
