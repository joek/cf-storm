module OrganizationHelpers
  def organization_path org
    "/organizations/#{URI.escape(org.name)}"
  end

  def current_organization
    return current_user.current_organization
    nil
  end
end
