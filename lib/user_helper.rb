module UserHelper

  def current_user
    # @current_user ||= 
    User[session['current_user_id']]
    #@spaces         = 
  end

  def session
    req.session
  end

  def user_avatar_path(user, size=30)
    "http://www.gravatar.com/avatar/#{user.avatar_file}?s=#{size}"
  end

  def space_path(space)
    "/spaces/#{space.name}/apps"
  end

end
