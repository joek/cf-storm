class Spaces < Cuba
  Cuba.plugin Cuba::With

  define do

    on ':space_name/apps/:app_name' do |space_name, app_name|
      with :space_name => space_name, :app_name => app_name do
        run Apps
      end
    end

    on get, ':space_name/apps' do |space_name|
      # @spaces = current_user.spaces
      @space  = current_user_spaces.find{ |s| s.name  == space_name }
      res.write view('apps/index')
    end
  end

end
