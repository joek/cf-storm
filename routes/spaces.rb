class Spaces < Cuba
  Cuba.plugin Cuba::With


  define do

    on get, 'new' do
      res.write view('spaces/new')
    end

    on post, param(:space_name)  do |space_name|
      begin
        current_user.create_space! space_name
        set_flash! 'Space created successful'
        res.redirect root_path
      rescue CFoundry::SpaceNameTaken
        set_flash! "Space name '#{space_name}' is already taken"
        res.redirect new_path(:spaces)
      end
    end

    on ':space_name/apps/:app_name' do |space_name, app_name|
      with :space_name => space_name, :app_name => app_name do
        run Apps
      end
    end

    on get, ':space_name/apps' do |space_name|
      @space  = current_user_spaces.find{ |s| s.name  == URI.unescape(space_name) }

      if @space.nil?
        set_flash! "The space '#{space_name}' does not exists"
        res.write view('shared/not-found')
      else
        res.write view('apps/index')
      end
    end

    # Nothing matched the request address
    on default do
      res.write view('404')
      res.status = 404
    end

  end

end
