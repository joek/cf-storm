class Sessions < Cuba

  def create! email, password, endpoint=nil
    @user = User.authenticate email, password, endpoint
    if @user
      session['current_user_id'] = @user.id
      res.redirect root_path
    else
      set_flash! 'Invalid credentials', :alert
      res.redirect "/sessions/new"
    end
  end

  define do
    on get, 'new' do
      res.write view('session/new')
    end

    on get, 'delete' do
      session.delete 'current_user_id'
      res.redirect '/sessions/new'
    end

    on post, param("email"), param("password"), 
             param("endpoint") do |email, password, endpoint|
      create! email, password, endpoint
    end

    on post, param("email"), param("password") do |email, password|
      create! email, password
    end
    
    on default do 
      set_flash! 'Invalid credentials', :alert
      res.redirect "/sessions/new"
    end  
    
  end
end
