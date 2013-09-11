class Spaces < Cuba
  Cuba.plugin Cuba::With

  define do

    on ':space_name/apps/:app_name' do |space_name, app_name|
      with :space_name => space_name, :app_name => app_name do
        run Apps
      end
    end

    on get, ':space_name/apps' do |space_name|
      @space = current_user.spaces.find{ |s| s.name  == space_name }
      res.write view('apps/index', :space => @space, :apps => @space.apps)
    end
  end

end
