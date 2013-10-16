scope do
  setup do
    login_user!
    load_user
    load_default_space_and_app
  end

  test 'I see the users list and I see myself in the list' do
    click_link 'Users'
    within('#users-list') do
      assert has_content? Settings::API_TEST_USERNAME
    end
  end

  test 'I see my own profile' do
    with_hidden_elements do
      click_link 'Profile'
    end
    within('#user-info') do
      assert has_content? @user.email
      assert has_content? @user.given_name
      assert has_content? @user.family_name
      assert has_content? @user.name
    end
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
    assert has_content? 'Password updated succesfully'
  end
end
