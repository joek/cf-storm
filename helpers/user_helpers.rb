module UserHelpers

  def current_user
    @current_user ||= User[session['current_user_id']]
  end

  def current_user_spaces
    @spaces ||= current_user.spaces if current_user
  end

  def session
    req.session
  end

  def user_avatar_path(user, size=30)
    "http://www.gravatar.com/avatar/#{user.avatar_file}?s=#{size}"
  end

end
