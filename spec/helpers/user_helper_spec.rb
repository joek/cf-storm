require_relative '../helper'

class FakeReq

  def session
    { 'current_user_id' => 1}
  end
end

describe UserHelper do
  include UserHelper

  def req
    FakeReq.new
  end

  it "Should returns the logged in user obj" do
    expect(current_user.kind_of? User).to be_true
  end

  it "should returns the logged in user from session" do
    expect(current_user.id).to eq req.session['current_user_id']
  end
end
