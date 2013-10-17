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

  test 'I delete a user' do
    user_count = req.current_organization.users.size
    click_link 'Users'
    within('#users-list') do
      all('.btn').first.click
    end
    assert req.current_organization.users.size < user_count
  end

  test 'I change my password' do
    with_hidden_elements do
      click_link 'Profile'
    end
    within('#user-pass') do
      fill_in 'old_password', :with => '12345678'
      fill_in 'password', :with => '1234'
      fill_in 'password_confirmation', :with => '1234'

      click_button 'Change'
    end
    assert has_content? 'Password changed succesfully'
  end

end
