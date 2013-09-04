class User  < Ohm::Model
  extend Forwardable

  def_delegators :client, :login, :spaces

  attribute :email
  attribute :token
  attribute :refresh_token

  index :email

  def client
    #require 'debugger' ; debugger
    @client ||= User.default_client.get User.api_url, cftoken
  end

  def cftoken
    CFoundry::AuthToken.new token, refresh_token
  end

  def cftoken=(cftoken)
    self.token         = cftoken.auth_header
    self.refresh_token = cftoken.refresh_token
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
    prev_default_client = User.default_client

    User.default_client = client_class
    yield
    @default_client = prev_default_client
  end

  def self.authenticate email, password
    user   = User.find(:email => email).first
    user ||= User.new :email => email

    begin
      token = user.login(:username => email, :password => password)
    rescue CFoundry::Denied
      return nil
    end

    user.cftoken = token
    user.save
  end

  require 'digest/md5'
  def avatar_file
    "#{Digest::MD5.hexdigest(self.email)}.png"
  end

end
