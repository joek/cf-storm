require_relative '../helper'

scope do
  setup do
    Capybara.app = Cuba.app
  end

  test 'when credentials are ok logins the user' do
    visit '/sessions/new'
    within('#session') do
      fill_in 'email', with: 'manuel.garcia@altoros.com'
      fill_in 'password', with: '12345678'
    end

    click_button 'Sign in'
    assert has_content? 'You are logged in as manuel.garcia@altoros.com'
  end

end
