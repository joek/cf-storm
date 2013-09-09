class Apps < Cuba;
  define do
    on get do
      space = current_user.spaces.find{ |s| s.name == vars[:space_name] }
      app = space.apps.find{ |a| a.name == vars[:app_name] }
      res.write view('apps/show', :app => app )
    end

    on post, param('state') do |state|
      space = current_user.spaces.find{ |s| s.name == vars[:space_name]}
      app = space.apps.find{ |a| a.name == vars[:app_name]}
      if app.started?
        app.stop!
      else
        app.start!
      end
      res.redirect "/spaces/#{vars[:space_name]}/apps"
    end
  end
end
