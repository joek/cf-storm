# -*- coding: utf-8 -*-
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

  # ------------------------------------------------------------------------
  # Context: Seeing app page 

  test 'I change app instances' do
    find("#app-details-#{@app.guid}").click
    within '#instance-quota' do
      assert find('.current-instances').value.to_i == @app.total_instances

      select '8', :from => 'instances'
      click_on 'Update'
    end

    assert has_content? 'Update successful'
  end


  test 'I change app instances beyond the quota so I get an error msg' do
    find("#app-details-#{@app.guid}").click
    within '#instance-quota' do
      assert find('.current-instances').value.to_i == @app.total_instances
      
      # instance limit is 10
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

  test 'I change app memory' do
    find("#app-details-#{@app.guid}").click
    within('#app-mem-form') do
      assert find('.current-app-mem').value.to_i == @app.memory

      select '1024', :from => 'memory'
      click_on 'Update'
    end
    assert has_content? 'Update successful'
  end

  
  test 'I change memory beyond the quota so I get an error msg' do
    find("#app-details-#{@app.guid}").click
    within('#app-mem-form') do
      assert find('.current-app-mem').value.to_i == @app.memory
      
      # Mem limit is 2048
      select '4096', :from => 'memory'
      click_on 'Update'
    end
    assert has_content? 'Update failed'
    @app.memory = 128
  end

  test 'I destroy the app' do

    find("#app-details-#{@app.guid}").click
    within('#app-destroy-form') do
      fill_in 'app_name', :with => @app.name
      click_button 'Destroy'
    end

    assert has_content? "#{@app.name} destroyed"

    within '#apps-list' do

      assert has_no_content? @app.name
    end

    FakeClient.reset!
  end

  test 'I try to destroy an app filling with a different name so I get an error msg' do

    find("#app-details-#{@app.guid}").click

    within('#app-destroy-form') do
      fill_in 'app_name', :with => "fruta"
      click_button 'Destroy'
    end

    assert has_content? "\"fruta\" and \"#{@app.name}\" " +
       "does not match, app was not destroyed"
  end


  test 'I try to destoy an app without filling the name so I get an error msg' do

    find("#app-details-#{@app.guid}").click

    within('#app-destroy-form') do
      click_button 'Destroy'
    end

    assert has_content? "No name provided for \"#{@app.name}\", " +
                 "app was not destroyed"
  end


  test 'I add a URL to the app' do
    find("#app-details-#{@app.guid}").click
    within('#app-uris') do
      fill_in 'url', :with => 'new.url'
    end
    click_button 'Add URL'
    assert has_content? 'URL Added to the app'
    assert find('#app-uris')
    within('#app-uris') do
      assert has_content? 'http://new.url.lolmaster.com'
    end
  end

  test 'I try to re-add an existing URL so I get an error msg' do
    find("#app-details-#{@app.guid}").click
    within('#app-uris') do
      assert has_content? 'new.url.lolmaster.com'
    end
    within('#app-uris') do
      fill_in 'url', :with => 'new.url'
    end
    click_button 'Add URL'
    assert has_content? 'Route is already taken'
    assert find('#app-uris')
  end

  test 'I remove one of the URLs from the app' do
    find("#app-details-#{@app.guid}").click
    route = @app.routes.first
    within('#app-uris') do
       find("#unmap-#{route.guid}").click
    end
    assert has_content? 'Route unmapped successfully'
    assert find('#app-uris')
    assert has_no_content? route.name
  end

  
  test 'I remove the last URL from the app' do
    @app.reset_routes!
    find("#app-details-#{@app.guid}").click
    route = @app.routes.first
    within('#app-uris') do
      find("#unmap-#{route.guid}").click
      with_hidden_elements do
        find(".unmap-confirmed").click
      end

    end
    assert has_content? 'Route unmapped successfully'
    assert find('#app-uris')
    assert has_no_content? route.name
    @app.reset_routes!
  end

  test 'I visit a non-existent page so I get an error msg but not an exception' do
    visit "#{req.space_path(@space)}/non-exist"
    assert has_content? "The app 'non-exist' does not exists in '#{@space.name}' space"
  end

  test 'I visit an app page when it\'s stopped so I dont\'t get an exception' do
    @app.stop!

    visit req.app_path(@space, @app)
    assert page.status_code == 200
  end
end
