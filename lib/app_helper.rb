module AppHelper
  def flash kind=:notice
    session_flash.delete kind
  end

  def set_flash! text, kind=:notice
    session_flash[kind] = text
  end

  def flash? kind=nil
    kind ? session_flash.keys.include?(kind) : session_flash.keys.any?
  end

  private
  def session_flash
    session[:flash] ||= {}
  end

end
