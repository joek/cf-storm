require_relative '../helper'

describe User do

  before do
    @email          = "manuel.garcia@altoros.com"
    @user           = User.new
    @password       = "12345678"
    @cf_description = "Cloud Foundry sponsored by Pivotal"
  end

  it "Should be able to login against CF api" do
    expect(@user.login :username => @email,
                       :password => @password).to be_true
  end

  it "Should be able to get info from cloudfoundry" do
    expect(@user.client.info[:description]).to eq(@cf_description)
  end

  it "authenticates should login to CF api and return a User obj" do
   user = User.authenticate @email, @password
   expect(user.email).to eq(@email)
  end

  it "should create local user when succesfully logged in" do
    users_count_before_login = User.all.size
    @a_user = User.new
    @a_user.should_receive(:login).and_return(true)
    User.stub!(:new).and_return(@a_user)
    User.authenticate "an@example.com", "apass"
    expect(User.all.size).to eq(users_count_before_login + 1)
  end
end
