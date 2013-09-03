require_relative './acceptance_helper'

scope do
  test 'when credentials are ok logins the user' do
    login_user!
    assert has_content? 'You are logged in as manuel.garcia@altoros.com'
  end

end
