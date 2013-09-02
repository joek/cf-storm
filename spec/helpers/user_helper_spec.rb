require_relative '../helper'

describe UserHelper do
  include UserHelper

  it "Should returns the logged in user obj" do
    expect(current_user.kind_of? User).to be_true
  end
end
