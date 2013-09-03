require_relative '../helper'

scope do
  setup do
    @email          = "manuel.garcia@altoros.com"
    @user           = User.new
    @password       = "12345678"
    @cf_description = "Cloud Foundry sponsored by Pivotal"
  end

  test "Should be able to login against CF api" do
    assert @user.login :username => @email,
    :password => @password
  end

  test "Should be able to get info from cloudfoundry" do
    assert @user.client.info[:description] == @cf_description
  end

  test "authenticates should login to CF api and return a User obj" do
    user = User.authenticate @email, @password
    assert user.email == @email
  end

  test "should create local user when succesfully logged in" do
    users_count_before_login = User.all.size

    User.authenticate "an@example.com", "apass"
    assert User.all.size == users_count_before_login + 1
  end

  test 'should reject invalid user' do
    User.with_default_client(FakeClientLoginFail) do
      assert User.authenticate('invalid@mail.com', 'asd') == nil
    end
  end
end
