class Apps < Cuba

  def load_app
    @space = current_user.spaces.find{ |s| s.name == vars[:space_name] }
    @app   = @space.apps.find{ |a| a.name == vars[:app_name] }
  end

  define do
    on get do
      load_app
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
      @app.update!

      set_flash! 'Update successful'
      res.redirect "/spaces/#{@space.name}/apps/#{@app.name}"

    end
  end
end
