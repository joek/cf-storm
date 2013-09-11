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
  end
end
