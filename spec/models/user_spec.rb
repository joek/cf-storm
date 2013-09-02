require_relative '../helper'

describe User do

  before do
    @api_url        = 'http://api.run.pivotal.io'
    @email          = "manuel.garcia@altoros.com"
    @password       = "12345678"
    @user           = User.get @api_url
    @cf_description = "Cloud Foundry sponsored by Pivotal"
  end

  it "Should be able to login against CF api" do
    expect(@user.login :username => @email,
                       :password => @password).to be_true
  end

  it "Should be able to get info from cloudfoundry" do
    expect(@user.info[:description]).to eq(@cf_description)
  end
end
