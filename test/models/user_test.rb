scope do
  setup do
    @email          = Settings::API_TEST_USERNAME
    @user           = User.new :email => @email
    @password       = Settings::API_TEST_PASSWORD
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
    User.find(:email => @email).first.delete
    users_count_before_login = User.all.size

    User.authenticate @email, @password
    assert User.all.size == users_count_before_login + 1
  end

  test "should store the token and use it to get a client and avoid re-login" do
    User.authenticate @email, @password
    user = User.find(:email => @email).first

    assert user.client.spaces
  end

  test 'should return avatar url'do
    user = User.new :email => 'lolmaster@example.com'
    assert user.avatar_file == "a7d174ed732e7799e762a184d5213193.png"
  end

  test 'should cache the CFoundry client after first called to avoid extra requests'do 
    User.clear_client_cache!
    
    assert User.clients.empty? 

    user = User.new :email => @email
    user.client

    assert User.clients.size == 1
  end
  
  test 'authenticates against a different api' do 
    User.find(:email => @email).first.delete
    user = User.new :email => @email, :api_url => 'custom_api.cf.com'
    assert User.authenticate(user.email, @password)
  end  

  test 'user client should use custom api provided by the user when data is valid' do 
    user = User.new :email => @email, :api_url => 'custom_api.cf.com'
    
    assert user.client.target == user.endpoint
  end

 end
