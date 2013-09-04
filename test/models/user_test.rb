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
    User.find(:email => "manuel.garcia@altoros.com").first.delete
    users_count_before_login = User.all.size

    User.authenticate "manuel.garcia@altoros.com", '12345678'
    assert User.all.size == users_count_before_login + 1
  end

  test 'should reject invalid user' do
    assert User.authenticate('invalid@mail.com', 'asd') == nil
  end

  test "should store the token and use it to get a client and avoid re-login" do
    User.authenticate "manuel.garcia@altoros.com", '12345678'
    user = User.find(:email => "manuel.garcia@altoros.com").first

    assert user.client.spaces
  end

  test 'should return avatar url'do
    user = User.new :email => 'lolmaster@example.com'
    assert user.avatar_file == "a7d174ed732e7799e762a184d5213193.png"
  end
end
