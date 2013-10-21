# JavaScript capable testing
scope do
  setup do
    set_js_driver
    login_user!
    load_default_space_and_app
    @app.health_with(1, 0)
  end

  # Context: Seeing an app from developemnt space
  test 'I visit the lolmaster app details' do
    find("#app-details-#{@app.guid}").click
    assert_app_details @app
  end

  test 'I see the stats of an app' do
    find("#app-details-#{@app.guid}").click
    expected_cpu_usage  = req.cpu_usage(@app.stats['0'][:stats][:usage][:cpu])
    expected_mem_usage  = req.to_megabytes(@app.stats['0'][:stats][:usage][:mem])
    expected_disk_usage = req.to_megabytes(@app.stats['0'][:stats][:usage][:disk])
    expected_uptime     = req.human_time(@app.stats['0'][:stats][:uptime])
    within('#app-stats') do
      assert find('.cpu-usage').text == expected_cpu_usage
      assert find('.mem-usage').text == expected_mem_usage
      assert find('.disk-usage').text == expected_disk_usage
      assert find('.uptime').text == expected_uptime
      assert find('.instance-state').text == @app.stats['0'][:state]
    end
  end

  test 'I see the health of an app as 100 when all instances are up' do
    find("#app-details-#{@app.guid}").click
    with_hidden_elements do
      assert find('#current-health')['value'] == "100"
    end
  end

  test 'I see the app services' do
    test_service = @app.service_bindings.first

    find("#app-details-#{@app.guid}").click

    within('#app-services') do
      assert has_content? test_service.service_instance.name
      assert has_content? test_service.service_instance.service_plan.name
    end
  end
end
