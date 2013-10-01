class Users < Cuba

  define do
    on get do
      @users = current_user.client.organizations.first.users
      res.write view('users/index')
    end
  end
end
