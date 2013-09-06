scope do
  setup do
    login_user!
    # user = User.all.first
    space = current_user.spaces.find{ |s| s.name == 'development'}
    @app = space.apps.find{ |a| a.name == 'DOS' }

  end

  test 'Given I have a space called development and I have an app called lolmaster' +
       'there I should be able to see its details' do
    click_link @app.name
    assert_app_details @app
  end
end
