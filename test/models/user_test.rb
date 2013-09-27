scope do
  setup do
    @email          = Settings::API_TEST_USERNAME
    @user           = User.new :email => @email
    @password       = Settings::API_TEST_PASSWORD
    @cf_description = "Cloud Foundry sponsored by Pivotal"
  end

  # User
  test "It logs in with valid data and valid endpoint" do
    assert @user.login :username => @email,
    :password => @password
  end

  test "It gets info from cloudfoundry" do
    assert @user.client.info[:description] == @cf_description
  end

  # User#authenticate
  test "It authenticates with valid data and returns an object" do
    user = User.authenticate @email, @password
    assert user.email == @email
  end

  test "Creates a DB record when logs in for first time" do
    User.find(:email => @email).first.delete
    users_count_before_login = User.all.size

    User.authenticate @email, @password
    assert User.all.size == users_count_before_login + 1
  end

  test "Stores client tokens" do
    User.authenticate @email, @password
    user = User.find(:email => @email).first

    assert user.client.spaces
  end

  test 'Creates a hash to fetch a gravatar' do
    user = User.new :email => 'lolmaster@example.com'
    assert user.avatar_file == "a7d174ed732e7799e762a184d5213193.png"
  end

  test 'Caches the authenticated CFoundry client object' do
    User.clear_client_cache!

    assert User.clients.empty?

    user = User.new :email => @email
    user.client

    assert User.clients.size == 1
  end

  test 'Authenticates against a different api' do
    User.find(:email => @email).first.delete
    user = User.new :email => @email, :api_url => 'custom_api.cf.com'
    assert User.authenticate(user.email, @password)
  end

  test 'After login with custom api CF client uses custom api' do
    user = User.new :email => @email, :api_url => 'custom_api.cf.com'

    assert user.client.target == user.endpoint
  end

 end
