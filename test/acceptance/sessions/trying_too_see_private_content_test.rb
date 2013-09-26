scope do

  # Context: visitor
  test 'I try visit private section so I get back to login' do
    visit '/spaces/development/apps'
    assert page.find '#new-session'
  end

  test "I try to see private content, main menu" do
    visit '/'
    assert_raise Capybara::ElementNotFound do
      page.find '#nav-menu'
    end
  end

  test 'I try to login with fake credentials so I get an error msg' do
    visit '/sessions/new'
    within('#new-session') do
      fill_in 'email', with: 'invalid_mail@example.com'
      fill_in 'password', with: 'invalid_password'
    end

    click_button 'Sign in'

    assert has_content? 'Invalid credentials'
  end
  
  test 'I try to log in with no credentials so I get an error msg' do
    visit '/sessions/new'
    click_button 'Sign in'
    
    assert has_content? 'Invalid credentials'
  end  


  # ----------------------------------------------------------------------------
  # Context: A real user
  test 'I login with real credentials' do
    login_user!
    avatar = page.find('#user-avatar')
    assert avatar[:title] == "You are logged in as #{Settings::API_TEST_USERNAME}"
  end
end
