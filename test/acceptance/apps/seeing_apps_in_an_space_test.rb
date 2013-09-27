# -*- coding: utf-8 -*-

scope do

  setup do
    login_user!
    load_default_space_and_app
  end


  # Context: I am logged in, I have a space called development, I have some apps there
  #          and I visit the apps list page
  test 'I visit the apps list of development' do
    visit '/spaces/development/apps'

    assert has_content? "Development"

    within('#apps-list') do
      assert has_content? "Windows 8"
      assert has_content? "Win95"
      assert has_content? "DOS"
    end
  end

  test 'I see a main menu' do
    assert page.find '#nav-menu'
  end

  test 'I see the state of each app in the list' do
    visit '/spaces/development/apps'
    assert has_css? '.app-state-started'
  end

  test 'I see a list of spaces' do
    with_hidden_elements do
      current_user.spaces.each{|s| find("#space-#{s.guid}")}
    end
  end

  test 'I select a space from the list so it becomes my current space' do
    space = current_user.spaces[1]

    with_hidden_elements do
      within("#nav-menu") do
        click_on "space-#{space.guid}"
      end
      assert find('#current-space').text == req.space_human_name(space)
    end
  end

  test 'I am redirected to the apps list when I visit the root' do
    visit '/'
    assert find('#apps-list')
  end

  test 'I see a page with error 404 after visiting a non-existent page' do
    visit '/spaces/non-existing'
    assert has_content? "Error 404, Not found"
  end

  test 'I don\'t get an exception when visiting a non-existent page' do
    visit "/spaces/non-existing/apps"
    assert has_content? "The space 'non-existing' does not exists"

  end

  test 'I don\'t get an exception when visiting a space with weird characters' do
    @space.name = 'lol master & weee'
    visit req.space_path(@space)
    assert page.status_code == 200
  end

  test 'I don\'t get an exception when visiting an app with weird characters' do
    @app.name = 'app & master sup'
    visit req.app_path(@space, @app)
    assert page.status_code == 200
  end

 end
