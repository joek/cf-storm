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
 
  private
  def session_flash
    session[:flash] ||= {}
  end

end
