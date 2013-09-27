class User  < Ohm::Model
  extend Forwardable

  def_delegators :client, :login, :domains, :route,
                 :domains_by_name, :spaces, :space_by_name

  attribute :email
  attribute :token
  attribute :refresh_token
  attribute :api_url

  index :email
  index :api_url

  def initialize(*args)
    @@_clients ||= {}
    super
  end
  
  def self.clear_client_cache!
    @@_clients = {}
  end

  def self.clients
    @@_clients
  end

  def current_organization
    client.current_organization || client.organizations.first
  end

  def create_space!(name)
    space = client.space
    space.organization = current_organization
    space.name         = name
    space.create!
  end

  def self.authenticate email, password, endpoint = nil
    user   = User.find(:email => email, :api_url => endpoint).first
    user ||= User.new :email => email, :api_url => endpoint

    token = user.login(:username => email, :password => password)
    user.cftoken = token
    user.save
  end
  
  def client_key
    self.endpoint + self.email 
  end  

  def client
    @@_clients[self.client_key] = client_get! unless @@_clients[self.client_key]
     
    refresh_tokens! if token_expired? 
    return @@_clients[self.client_key]
  end
  
  def client_get!
    User.default_client.get self.endpoint, cftoken
  end
  
  def endpoint 
    self.api_url || User.api_url
  end
  
  def refresh_tokens!
    self.cftoken = @@_clients[self.client_key].token
    self.save
  end
 
  def token_expired?
    @@_clients[self.client_key].token.auth_header != self.token
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
    Settings::API_URL
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

  require 'digest/md5'
  def avatar_file
    "#{Digest::MD5.hexdigest(self.email)}.png"
  end

end
