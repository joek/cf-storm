module UserHelpers

  def current_user
    @current_user ||= User[session['current_user_id']]
  end

  def current_user_spaces
    @spaces ||= current_user.spaces(:depth => 0) if current_user
  end

  def load_app(space_name, app_name)
    unescaped_app_name = URI.unescape(app_name)
    load_space space_name
    @app = @apps.find{ |a| a.name == unescaped_app_name }
  end

  def load_space(space_name)
    unescaped_space_name = URI.unescape space_name

    @space ||= current_user_spaces.find do |s|
      s.name  == URI.unescape(unescaped_space_name)
    end

    @apps ||= @space.apps(:depth => 0) unless @space.nil?
    @space
  end

  def session
    req.session
  end

  def user_avatar_path(user, size=30)
    "http://www.gravatar.com/avatar/#{user.avatar_file}?s=#{size}"
  end

  def users_path
    '/users'
  end

end
