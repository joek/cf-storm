module MainHelpers
  def flash kind=:notice
    session_flash.delete kind
  end

  def set_flash! text, kind=:notice
    session_flash[kind] = text
  end

  def flash? kind=nil
    kind ? session_flash.keys.include?(kind) : session_flash.keys.any?
  end

  def organization_path org
    "/organizations/#{org.name}"
  end

  def root_path
    space_path current_user_spaces.first
  end

  def new_path(resource)
    "/#{resource}/new"
  end

  def app_release_date
    Time.parse(raw_version.last).strftime('%d/%m/%Y %H:%M')
  end

  def app_version
    raw_version.first
  end

  private
  def session_flash
    session[:flash] ||= {}
  end

  def raw_version
    version_file = File.open('version', 'r')
    data = version_file.read
    version_file.close

    data.split("\n")
  end
end
