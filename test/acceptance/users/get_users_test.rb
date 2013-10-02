scope do
  setup do
    login_user!
    load_default_space_and_app
  end

  test 'I see the users list and I see myself in the list' do
    click_link 'Users'
    within('#users-list') do
      assert has_content? Settings::API_TEST_USERNAME
    end
  end
end
