class User  < Ohm::Model
  extend Forwardable

  def_delegators :client, :login, :spaces

  attribute :email
  index :email

  def client
    @client ||= User.default_client.get User.api_url
  end

  def self.default_client
    @default_client || CFoundry::Client
  end

  def self.api_url
    'http://api.run.pivotal.io'
  end

  def self.default_client=(client)
    @default_client = client
  end

  def self.with_default_client(client_class)
    User.default_client = client_class
    yield
    @default_client = nil
  end

  def self.authenticate email, password
    user   = User.find(:email => email).first
    user ||= User.new :email => email

    begin
      user.login :username => email, :password => password
    rescue CFoundry::Denied
      return nil
    end

    user.save
  end

end
