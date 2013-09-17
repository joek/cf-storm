class Spaces < Cuba
  Cuba.plugin Cuba::With

  define do

    on ':space_name/apps/:app_name' do |space_name, app_name|
      with :space_name => space_name, :app_name => app_name do
        run Apps
      end
    end

    on get, ':space_name/apps' do |space_name|
      @space  = current_user_spaces.find{ |s| s.name  == space_name }
      
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
