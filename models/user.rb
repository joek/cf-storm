module MetalFoundrySources
  def raw_spaces
    url = "/v2/users/#{@cf_client.current_user.guid}/spaces"
    client.request('GET', url)
  end

  def raw_apps space_guid
    url = "/v2/spaces/#{space_guid}/apps"
    client.request('GET', url)
  end

  def raw_routes app_guid
    url = "/v2/apps/#{app_guid}/routes"
    client.request('GET', url)
  end

  def raw_stats app_guid
    url = "/v2/apps/#{app_guid}/stats"
    client.request('GET', url)
  end

  def raw_instances app_guid
    url = "/v2/apps/#{app_guid}/instances"
    client.request('GET', url)
  end

end

class MetalFoundry
  require 'json'
  include MetalFoundrySources

  def initialize(cf_client)
    @cf_client = cf_client
  end

  def self.client
    @client
  end

  def client
    @client ||= CFoundry::RestClient.new User.api_url, @cf_client.token
  end

  def spaces
    return @spaces unless @spaces.nil?
    _spaces = JSON.parse raw_spaces[1][:body]
    @spaces ||= _spaces["resources"].map do |s|
      Space.new s["entity"]["name"], s["metadata"]["guid"], client
    end
  end
end


class Space
  include MetalFoundrySources
  attr_accessor :name, :guid, :client

  def initialize name, guid, client
    self.name   = name
    self.guid   = guid
    self.client = client
  end

  def apps
    @apps ||= fetch_apps(self.guid)
  end

  def fetch_apps(space_guid)
    _apps = JSON.parse raw_apps(space_guid)[1][:body]

    _apps["resources"].map do |a|
      App.new a["entity"]["name"], a["entity"]["state"],
      "google.com", a["metadata"]["guid"], client
    end
  end
end


class App
  include MetalFoundrySources
  attr_accessor :name, :state, :url, :guid, :client

  def initialize name, state, url, guid, client
    self.name  = name
    self.state = state
    self.url   = url
    self.guid  = guid
    self.client = client
  end

  def started?
    self.state == "STARTED"
  end

  def routes
    _routes = JSON.parse raw_routes(self.guid)[1][:body]

    _routes
  end
end


class User  < Ohm::Model
  extend Forwardable

  def_delegators :client, :login, :domains, :route,
                 :domains_by_name

  attribute :email
  attribute :token
  attribute :refresh_token

  index :email

  def spaces
    # return client.spaces
    @mf ||= MetalFoundry.new(self.client)
    @mf.spaces
  end

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

  def client
    return @@_clients[self.email] unless  @@_clients[self.email].nil?
    @@_clients[self.email] = User.default_client.get User.api_url, cftoken
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
    # 'http://api.nise.cloudfoundry.altoros.com'
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
