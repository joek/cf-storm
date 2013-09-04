require_relative './acceptance_helper'

scope do
  test 'when an invalid user tries to login' do
    visit '/sessions/new'
    within('#session') do
      fill_in 'email', with: 'invalid_mail@example.com'
      fill_in 'password', with: 'invalid_password'
    end

    click_button 'Sign in'

    assert has_content? 'Invalid credentials'
  end

end
