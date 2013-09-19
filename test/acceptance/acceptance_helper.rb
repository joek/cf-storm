include UsersHelper

prepare do
  Capybara.reset!
end

def login_user!
  visit '/sessions/new'
  within('#new-session') do
    fill_in 'email', with: 'manuel.garcia@altoros.com'
    fill_in 'password', with: '12345678'
  end

  click_button 'Sign in'
end

def assert_app_details app
  assert has_content? app.name.capitalize
  assert has_content? app.state
  assert has_content? app.memory
  assert has_content? app.instances.size
  app.uris.each {|u| assert has_content? u}
end

def load_default_space_and_app
  @space ||= current_user.spaces.find{ |s| s.name == 'development'}
  @app   ||= @space.apps.find{ |a| a.name == 'DOS' } || @space.apps.first
end

def with_hidden_elements
  Capybara.ignore_hidden_elements = false
  yield
  Capybara.ignore_hidden_elements = true
end
