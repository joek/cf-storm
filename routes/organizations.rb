class Organizations < Cuba

  def set_current_organization(org_name)
    organization = current_user.organizations.find{ |o| o.name == org_name }
    current_user.current_organization = organization
    @space = organization.spaces.first
  end

  define do
    on get do
      on ':org_name' do |org_name|
        set_current_organization org_name
        res.write view "apps/index", :space => @space, :apps => @space.apps
      end

    end

  end
end
