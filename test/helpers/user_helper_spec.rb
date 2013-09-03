require_relative '../helper'

class FakeReq
  include UserHelper

  def session
    { 'current_user_id' => 1}
  end
end

scope do

  def req
    FakeReq.new
  end

  test "Should returns the logged in user obj" do
    assert req.current_user.kind_of? User
  end

  test "should returns the logged in user from session" do
    assert req.current_user.id ==  req.session['current_user_id']
  end
end
