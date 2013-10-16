include UserHelpers

prepare do
  Capybara.reset!
end

def login_user!
  visit '/sessions/new'
  within('#new-session') do
    fill_in 'email', with: Settings::API_TEST_USERNAME
    fill_in 'password', with: Settings::API_TEST_PASSWORD
  end

  click_button 'Sign in'
end

def assert_app_details app
  assert has_content? app.name.capitalize
  assert has_content? app.state
  assert has_content? app.memory
  assert has_content? app.total_instances.size
  app.uris.each {|u| assert has_content? u}
end

def load_user
  @user ||= current_user
end

def load_default_space_and_app
  @space ||= current_user.current_organization.spaces.find{ |s| s.name == 'development'}
  @app   ||= @space.apps.find{ |a| a.name == 'DOS' } || @space.apps.first
end

def with_hidden_elements
  Capybara.ignore_hidden_elements = false
  yield
  Capybara.ignore_hidden_elements = true
end
