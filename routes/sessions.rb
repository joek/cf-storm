class Sessions < Cuba
  define do
    on get, 'new' do
      res.write view('session/new')
    end

    on get, 'delete' do
      session.delete 'current_user_id'
      res.redirect '/sessions/new'
    end

    on post do
      on param("email"), param("password") do |email, password|
        @user = User.authenticate email, password
        if @user
          session['current_user_id'] = @user.id
          res.redirect root_path
        else
          set_flash! 'Invalid credentials', :alert
          res.redirect "/sessions/new"
        end
      end
    
      on default do 
        set_flash! 'Invalid credentials', :alert
        res.redirect "/sessions/new"
       end  
    end
    
    
  end
end
