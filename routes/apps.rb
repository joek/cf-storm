class Apps < Cuba

  def load_app
    @space  = current_user_spaces.find{ |s| s.name == vars[:space_name] }
    @app    = @space.apps.find{ |a| a.name == vars[:app_name] }
  end

  def update_with_rescue(exception)
    begin
      @app.update!
      set_flash! 'Update successful'
    rescue exception
      set_flash! 'Update failed', :alert
    end
  end

  def destroy_and_set_flash!
    if @app.delete
      set_flash! "#{@app.name} destroyed"
    else
      set_flash! "#{@app.name} was not destroyed, a problem occured"
    end
  end

  def destroy_failed_and_set_flash! app_name=nil
    if app_name
      set_flash! "\"#{app_name}\" and \"#{@app.name}\" does not match," +
                   " app was not destroyed", :alert

    else
      set_flash! "No name provided for \"#{@app.name}\", " +
                 "app was not destroyed", :alert
    end

    res.redirect app_path @space, @app
  end

  define do
    
    load_app

    on get, 'map_url' do
      res.write view('apps/map_url')
    end

    on get do
      if @app.nil?
        set_flash! "The app '#{vars[:app_name]}' does not " + 
                   "exists in '#{@space.name}' space", :alert
        res.write view('shared/not-found')
      else
        @stats = @app.stats
        res.write view('apps/show')
      end 
    end

    on put, param('state') do |state|
      @app.started? ? @app.stop! : @app.start!

      res.redirect space_path @space
    end

    on post, param('instances') do |instances|
      @app.total_instances = instances.to_i
      update_with_rescue CFoundry::InstancesError

      res.redirect app_path @space, @app
    end

    on post, param('memory') do |memory|
      @app.memory = memory.to_i
      update_with_rescue CFoundry::AppMemoryQuotaExceeded

      res.redirect app_path @space, @app
    end

    on delete, param('app_name') do |app_name|
      if app_name == @app.name
        destroy_and_set_flash!
        res.redirect space_path @space
      else
        destroy_failed_and_set_flash! app_name
      end
    end

    on delete do
      destroy_failed_and_set_flash!
    end
  end
end
