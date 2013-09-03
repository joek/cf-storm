require_relative '../helper'

if ENV['INTEGRATION']
  User.default_client = nil
  puts " ==> Running with #{User.api_url}"
end

def login_user!
  visit '/sessions/new'
  within('#session') do
    fill_in 'email', with: 'manuel.garcia@altoros.com'
    fill_in 'password', with: '12345678'
  end

  click_button 'Sign in'
end
