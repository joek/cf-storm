class Organizations < Cuba;

  define do
    on get do
      on ':org_name' do |org_name|
        organization = current_user.organizations.find{ |o| o.name == org_name }
        current_user.current_organization = organization
        space = organization.spaces.first
        res.write view "apps/index", :space => space, :apps => space.apps
      end

    end

  end
end
