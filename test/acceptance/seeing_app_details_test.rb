scope do

  setup do
    login_user!
    load_default_space_and_app
  end

  test 'Given I have a space called development and I have an app called lolmaster' +
       'there I should be able to see its details' do
    find("#app-details-#{@app.guid}").click
    assert_app_details @app
  end

  test 'Given I have an app I should be able to see its stats' do
    find("#app-details-#{@app.guid}").click
    expected_cpu_usage = req.cpu_usage(@app.stats['0'][:stats][:usage][:cpu])

    assert find('#app-stats').find('.cpu-usage').text == expected_cpu_usage
  end

end
