# -*- coding: utf-8 -*-

scope do

  setup do
    login_user!
    load_default_space_and_app
  end

  test 'Given I logged in when there are some apps into the development space' do
    visit '/spaces/development/apps'

    assert has_content? "Development"

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
      within("#nav-menu") do
        click_on "space-#{space.guid}"
      end
      assert find('#current-space').text == req.space_human_name(space)
    end
  end

  test 'Given I logged in when I visit the root path I should be' +
       'redirected to apps index' do

    visit '/'
    assert find('#apps-list')
  end

  test 'Should return render 404 view trying to access to ' +
       'a non-existing url in spaces route' do

    visit '/spaces/non-existing'
    assert has_content? "Error 404, Not found"
  end

  test 'should not raise an error when I try to visit with a non-existing space app list' do

    visit "/spaces/non-existing/apps"
    assert has_content? "The space 'non-existing' does not exists"

  end

  test 'should not rise an error when visiting a space with weird characters' do
    @space.name = 'lol master & weee'
    visit req.space_path(@space)
    assert page.status_code == 200
  end

  test 'should not rise an error when visiting an app with weird characters' do
    @app.name = 'app & master sup'
    visit req.app_path(@space, @app)
    assert page.status_code == 200
  end

 end