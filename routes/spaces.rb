class Spaces < Cuba

  define do
    on get, ':space_name/apps' do |space_name|
      space = current_user.spaces.find{ |s| s.name == space_name }
      apps = space.apps
      res.write view('apps/index', :space => space, :apps => apps)
    end
  end

end
