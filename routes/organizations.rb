class Organizations < Cuba
  def set_current_organization! org_name
    current_user.current_organization = current_user.organizations(:depth => 0).find{ |o| o.name == URI.unescape(org_name) }
  end

  define do
    on get do
      set_current_organization! vars[:organization_name]

      on 'spaces' do
        run Spaces
      end

      on default do
        res.redirect root_path
      end

    end
  end
end
