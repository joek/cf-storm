scope do

  setup do
    login_user!
  end

  test 'Given I logged in when there are some apps into the development space' do
    visit '/spaces/development/apps'

    assert has_content? "Development's applications"

    within('#apps-list') do
      assert has_content? "Windows 8"
      assert has_content? "Win95"
      assert has_content? "DOS"
    end
  end

  test 'Given I logged in I should see main menu' do
    assert page.find '#nav-menu'
  end

  test 'Given I have an app I should be able to see its state' do
    visit '/spaces/development/apps'
    assert has_css? '.app-state-started'
  end

  test 'Given I logged in I should be able to logout' do
    click_link 'Logout'
    assert page.find '#new-session'
  end

  test 'Given I have some spaces i should be able to list them' do
    with_hidden_elements do
      current_user.spaces.each{|s| find("#space-#{s.guid}")}
    end
  end

  test 'Given I have some spaces and I select one from the list ' +
       'it should be shown as current space' do

    space = current_user.spaces[1]

    with_hidden_elements do
      click_link "#{space.name}"
      puts find('#current-space').text
      assert find('#current-space').text == space.name
    end
  end
 end
