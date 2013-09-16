class Apps < Cuba

  def load_app
    @space = current_user.spaces.find{ |s| s.name == vars[:space_name] }
    @app   = @space.apps.find{ |a| a.name == vars[:app_name] }
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

  define do
    on get do
      load_app
      @stats = @app.stats

      res.write view('apps/show')
    end

    on post, param('state') do |state|
      load_app
      @app.started? ? @app.stop! : @app.start!

      res.redirect space_path @space
    end

    on post, param('instances') do |instances|
      load_app
      @app.total_instances = instances.to_i
      update_with_rescue CFoundry::InstancesError

      res.redirect app_path @space, @app
    end

    on post, param('memory') do |memory|
      load_app
      @app.memory = memory.to_i
      update_with_rescue CFoundry::AppMemoryQuotaExceeded
 
      res.redirect app_path @space, @app
    end
    
    on post, param('app_name') do |app_name|
      load_app

      if app_name == @app.name
        destroy_and_set_flash!
        res.redirect space_path @space
      else
        set_flash! "\"#{app_name}\" and \"#{@app.name}\" does not match," + 
                   " app was not destroyed", :alert
        
        res.redirect app_path @space, @app
      end
    end
  end
end
