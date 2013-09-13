scope do

  setup do
    login_user!
    load_default_space_and_app
  end

  test 'Given Im seeing apps in development space then I ' +
       'should be able to stop an app' do

    click_on "stop-#{@app.name}"
    assert find("#start-#{@app.name}")
  end

  test 'should be able to visit the app url' do
    app_url_href = find("#app-url-#{@app.name}")['href']
    assert app_url_href == "http://#{@app.url}"
  end

  test 'should be able to change number of instances' do
    find("#app-details-#{@app.guid}").click
    within '#instance-quota' do
      assert find('.current-instances').value.to_i == @app.total_instances

      select '8', :from => 'instances'
      click_on 'Update'
    end

    assert has_content? 'Update successful'
  end

  # instance limit is 10
  test 'should not update instances if exedes instance limit' do
    find("#app-details-#{@app.guid}").click
    within '#instance-quota' do
      assert find('.current-instances').value.to_i == @app.total_instances

      select '11', :from => 'instances'
      click_on 'Update'
    end

    assert has_content? 'Update failed'
    assert find('.current-instances').value.to_i == @app.total_instances

    # This is needed because we don't implement the array of instances
    # to provide this value, and instances are 11 after last test, this
    # makes fail the next one
    @app.total_instances = 8
  end

  test 'should be able to change ammount of memory of an app' do
    find("#app-details-#{@app.guid}").click
    within('#app-mem-form') do
      assert find('.current-app-mem').value.to_i == @app.memory

      select '1024', :from => 'memory'
      click_on 'Update'
    end
    assert has_content? 'Update successful'
  end

  # Mem limit is 2048
  test 'should not update memory if excedes limit' do
    find("#app-details-#{@app.guid}").click
    within('#app-mem-form') do
      assert find('.current-app-mem').value.to_i == @app.memory

      select '4096', :from => 'memory'
      click_on 'Update'
    end
    assert has_content? 'Update failed'
    @app.memory = 128
  end

  test 'should be able to destroy app' do
    find("#app-details-#{@app.guid}").click
    within('#app-destroy-form') do
      fill_in 'app_name', :with => @app.name
      click_button 'Destroy'
    end

    assert has_content? "#{@app.name} destroyed"

    within '#apps-list' do
      assert has_no_content? @app.name
    end
  end
end
