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
end
