scope do

  setup do
    login_user!
    load_default_space_and_app
  end

  test 'Given Im seeing apps in development space then I should be able
       to stop an app' do

    click_on "stop-#{@app.name}"
    assert find("#start-#{@app.name}")
  end

  test 'should be able to visit the app url' do
    assert find("#app-url-#{@app.name}")['href'] == "http://#{@app.url}"
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
  end

end
