require_relative '../helper'

describe 'A user should be able to login' , :type => :feature do
  before do
    Capybara.app = Cuba.app
  end

  context 'when credentials are ok' do
    it 'logins the user' do
      visit '/sessions/new'
      within('#session') do
        fill_in 'Email', with: 'manuel.garcia@altoros.com'
        fill_in 'Password', with: '12345678'
      end

      click_button 'Sign in'
      expect(page).to have_content 'You are logged in as manuel.garcia@altoros.com'
    end
  end
end
