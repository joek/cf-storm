prepare do
  Capybara.reset!
end

def login_user!
  visit '/sessions/new'
  within('#session') do
    fill_in 'email', with: 'manuel.garcia@altoros.com'
    fill_in 'password', with: '12345678'
  end

  click_button 'Sign in'
end
