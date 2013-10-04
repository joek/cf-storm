scope do
  setup do
    login_user!
    load_default_space_and_app
  end

  test 'I create a user with default permissions' do
    click_link 'Users'
    within('#new-user-form') do
      fill_in 'email', :with => 'lol.master@example.com'
      fill_in 'password', :with => '123456789'

      click_button 'Register'
    end
    
    assert has_content? 'lol.master@example.com'
  end
end