module UserHelper

  def current_user
    User[session['current_user_id']]
  end

  def session
    req.session
  end

end
