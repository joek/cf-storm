module UserHelper

  def current_user
    User[session['current_user_id']]
  end

  def current_organization
    current_user.current_organization || current_user.organizations.first
  end

  def session
    req.session
  end

  def user_avatar_path(user, size=30)
    "http://www.gravatar.com/avatar/#{user.avatar_file}?s=#{size}"
  end

end
