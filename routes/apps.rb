class Apps < Cuba;
  define do
    on get do
      space = current_user.spaces.find{ |s| s.name == vars[:space_name] }
      app = space.apps.find{ |a| a.name == vars[:app_name] }
      res.write view('apps/show', :app => app )
    end

    on post do
      res.write 'LOLMASTER'
    end
  end
end
