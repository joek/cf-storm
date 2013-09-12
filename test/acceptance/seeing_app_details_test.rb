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
    expected_cpu_usage  = req.cpu_usage(@app.stats['0'][:stats][:usage][:cpu])
    expected_mem_usage  = req.to_megabytes(@app.stats['0'][:stats][:usage][:mem])
    expected_disk_usage = req.to_megabytes(@app.stats['0'][:stats][:usage][:disk])
    expected_uptime     = req.human_time(@app.stats['0'][:stats][:uptime])

    within('#app-stats') do
      assert find('.cpu-usage').text == expected_cpu_usage
      assert find('.mem-usage').text == expected_mem_usage
      assert find('.disk-usage').text == expected_disk_usage
      assert find('.uptime').text == expected_uptime
    end

  end

end
