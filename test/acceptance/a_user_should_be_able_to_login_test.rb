scope do
  test 'when credentials are ok logins the user' do
    login_user!
    avatar = page.find('#user-avatar')
    assert avatar[:title] == "You are logged in as #{Settings::API_TEST_USERNAME}"
  end
end
