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

  test 'when a guest with wrong credentials tries to login' do
    visit '/sessions/new'
    within('#new-session') do
      fill_in 'email', with: 'invalid_mail@example.com'
      fill_in 'password', with: 'invalid_password'
    end

    click_button 'Sign in'

    assert has_content? 'Invalid credentials'
  end
  
  test 'when a guest does not fill the username and pass' do
    visit '/sessions/new'
    click_button 'Sign in'
    
    assert has_content? 'Invalid credentials'
  end  

  test 'when credentials are ok logins the user' do
    login_user!
    avatar = page.find('#user-avatar')
    assert avatar[:title] == "You are logged in as #{Settings::API_TEST_USERNAME}"
  end
end
