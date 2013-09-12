class Apps < Cuba

  def load_app
    @space = current_user.spaces.find{ |s| s.name == vars[:space_name] }
    @app   = @space.apps.find{ |a| a.name == vars[:app_name] }
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

      res.redirect "/spaces/#{@space.name}/apps"
    end

    on post, param('instances') do |instances|
      load_app
      @app.total_instances = instances.to_i
      begin
        @app.update!
        set_flash! 'Update successful'
      rescue CFoundry::InstancesError
        set_flash! 'Update failed', :alert
      end
      res.redirect "/spaces/#{@space.name}/apps/#{@app.name}"
    end

    on post, param('memory') do |memory|
      load_app
      @app.memory = memory.to_i
      begin
        @app.update!
        set_flash! 'Update successful'
      rescue CFoundry::AppMemoryQuotaExceeded
        set_flash! 'Update failed', :alert
      end
      res.redirect "/spaces/#{@space.name}/apps/#{@app.name}"
    end
  end
end
