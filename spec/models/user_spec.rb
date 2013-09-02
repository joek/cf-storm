require_relative '../helper'

describe User do

  before do
    @email    = "manuel.garcia@altoros.com"
    @password = "12345678"
    @user     = User.new
  end

  it "Should be able to login against CF api" do
    expect(@user.login @email, @password).to be_true
  end
end
