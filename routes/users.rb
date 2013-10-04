class Users < Cuba

  define do
    on get do
      @users = current_user.current_organization.users
      res.write view('users/index')
    end
  end
end
