class Users < Cuba

  def create_user_and_set_flash! email, password
    # TODO Optimize this
    # TODO Add spaces
    # TODO Think what org add when creating
    new_user = current_user.client.register(email, password)
    
    current_user.organizations.each do |org|
      new_user.add_managed_organization org
      new_user.add_billing_managed_organization org
      new_user.add_audited_organization org
      new_user.organizations = current_user.organizations
    end

    new_user.update!
  end

  define do
    on get do
      @users = current_user.current_organization.users
      res.write view('users/index')
    end

    on post, param('email'), param('password') do |email, password|
      create_user_and_set_flash! email, password
      res.redirect 'users/index'
    end
  end
end
