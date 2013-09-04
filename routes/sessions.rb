class Sessions < Cuba
  define do
    on get, 'new' do
      res.write view('session/new')
    end

    on post do
      on param("email"), param("password") do |email, password|
        @user = User.authenticate email, password
        if @user
          session['current_user_id'] = @user.id

          res.redirect "/spaces/development/apps"
        else
          session[:error_message] = 'Invalid credentials'
          res.redirect "/sessions/new"
        end

      end
    end
  end
end
