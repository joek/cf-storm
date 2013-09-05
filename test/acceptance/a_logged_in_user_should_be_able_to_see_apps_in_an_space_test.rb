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

end
