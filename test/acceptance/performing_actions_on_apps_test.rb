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
      select '8', :from => 'instances'
      click_on 'Update'
    end
    assert has_content? 'Update successful'
  end

end
