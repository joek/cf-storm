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

  test 'should return user avatar url' do
    user = User.new :email => 'lolmaster@example.com'
    assert req.user_avatar_path(user) == "http://www.gravatar.com/avatar/#{user.avatar_file}?s=30"
  end

  test 'current_organization should return the first organization when client.current_organization is nil' do
    assert req.current_organization == req.current_user.organizations.first
  end
end
