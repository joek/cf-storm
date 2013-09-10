class Organizations < Cuba

  def set_current_organization(org_name)
    organization = current_user.organizations.find{ |o| o.name == org_name }
    current_user.current_organization = organization
    @space = organization.spaces.first
  end

  define do
    on post do
      on ':org_name' do |org_name|
        set_current_organization org_name
        res.redirect "/spaces/#{@space.name}/apps"
      end
    end
  end
end
