require_relative './acceptance_helper'

scope do
  test 'when credentials are ok logins the user' do
    visit '/spaces/development/apps'
    assert has_content? 'Login with your cf user'
  end

end
