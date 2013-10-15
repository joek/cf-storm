class Users < Cuba

  def create_user_and_set_flash! email, password
    # TODO Optimize this
    # TODO Add spaces
    # TODO Think what org add when creating
    new_user = current_user.client.register(email, password)

    new_user.add_managed_organization current_organization
    new_user.add_billing_managed_organization current_organization
    new_user.add_audited_organization current_organization
    new_user.organizations = current_organization

    current_user.spaces.each{|s| new_user.add_space s }

    new_user.update!
  end

  define do
    on get do
      @users = current_user.current_organization.users

      begin
        @users.first.email unless @users.empty?
        res.write view('users/index')
      rescue CFoundry::UAAError
        set_flash! "You are not allowed visit this section", :alert
        res.redirect root_path
      end
    end

    on post, param('email'), param('password') do |email, password|
      create_user_and_set_flash! email, password
      res.redirect 'users/index'
    end

    on post do
      res.redirect 'users/index'
    end

    on delete, param('user_guid') do |user_guid|
      user = current_organization.users(:depth => 0).find{|u| u.guid == user_guid}
      if user
        user.delete ? set_flash!('User deleted', :notice) : set_flash!('Something went wrong, try again later', :alert)
      end
      res.redirect users_path
    end
  end
end
