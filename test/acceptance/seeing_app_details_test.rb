scope do

  setup do
    login_user!
    load_default_space_and_app
  end

  test 'Given I have a space called development and I have an app called lolmaster' +
       'there I should be able to see its details' do
    click_link @app.name
    assert_app_details @app
  end
end
