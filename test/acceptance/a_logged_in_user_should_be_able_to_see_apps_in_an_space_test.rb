scope do

  test 'Given I logged in when there are some apps into the development space' do
    login_user!
    visit '/spaces/development/apps'

    assert has_content? "Development's applications"

    within('#apps-list') do
      assert has_content? "Windows 8"
      assert has_content? "Win95"
      assert has_content? "DOS"
    end
  end

  test 'Given I logged in I should see main menu' do
    login_user!
    assert page.find '#nav-menu'
  end

  test 'Given I have an app I should be able to see its state' do
    login_user!
    visit '/spaces/development/apps'
    assert has_css? '.app-state-started'
  end

  test 'Given I logged in I should be able to logout' do
    login_user!
    click_link 'Logout'
    assert page.find '#session'
  end
end
