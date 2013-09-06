module Helper
  def flash kind=:notice
    session_flash.delete kind
  end

  def set_flash! text, kind=:notice
    session_flash[kind] = text
  end

  def flash? kind=nil
    kind ? session_flash.keys.include?(kind) : session_flash.keys.any?
  end

  def app_path space, app
    "/spaces/#{space.name}/apps/#{app.name}"
  end

  private
  def session_flash
    session[:flash] ||= {}
  end

end
