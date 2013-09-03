class Sessions < Cuba
  define do
    on get do
      on 'new' do
        res.write view('session/new')
      end
    end

    on post do
      on param("email"), param("password") do |email, password|
        @user = User.authenticate email, password
        session['current_user_id'] = @user.id

        res.redirect "/apps"
      end
    end
  end
end
