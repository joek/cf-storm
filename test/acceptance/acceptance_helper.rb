include UserHelper

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
  assert has_content? app.name
  assert has_content? app.state
  assert has_content? app.memory
  assert has_content? app.instances.size
  app.uris.each {|u| assert has_content? u}
end

def load_default_space_and_app
  @space = current_user.spaces.find{ |s| s.name == 'development'}
  @app   = @space.apps.find{ |a| a.name == 'DOS' }
end

def load_default_organization
  @organization = current_user.organizations.delete_if do
    |o| o.name == current_user.current_organization.name
  end.first
end
