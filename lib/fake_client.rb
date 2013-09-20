class FakeClient

  # Complex Structs
  require_relative './fake_spaces'
  require_relative './fake_routes'
  require_relative './fake_apps'

  # Generic Structs
  Struct.new("Token", :auth_header, :refresh_token)
  Struct.new("Organization", :name, :spaces)
  Struct.new('Domain', :name)
  Struct.new('Instance', :state)

  def login(credentials)
    valid_usernames = ['manuel.garcia@altoros.com']
    if valid_usernames.include? credentials[:username]
      Struct::Token.new "my-auth-token", "my-refresh-token"
    else
      raise CFoundry::Denied
    end
  end

  def info
    {:description => "Cloud Foundry sponsored by Pivotal"}
  end

  def self.get(target, token = nil)
    new
  end

  def current_organization
    nil
  end

  def organizations
    [Struct::Organization.new("Acme", [])]
  end

  def space
    Struct::Space.new '', ''
  end

  def spaces
    @@_spaces ||=
    %w(development test production).map do |s|
      Struct::Space.new s, apps, Digest::MD5.hexdigest(s)
    end

    @@_spaces
  end

  def self.apps
    @@_apps
  end

  # name, state, memory, instances, uris, url, guid, total_instances
  def apps
    @@_apps ||=
    ["Windows 8", "Win95", "DOS"].map do |a|
      Struct::App.new a,         #name
                      'STARTED', #state
                       128,      #memory
                       {}, #stats
                       'mswin.run.io',    #url
                       Digest::MD5.hexdigest(a)  #guid
    end

    @@_apps
  end

  def self.reset!
    @@_apps = @@_spaces = nil
  end

  def domains
    @@_domains ||= [Struct::Domain.new('lolmaster.com'), Struct::Domain.new('run.io')]

    @@_domains
  end

  def route
    Struct::Route.new
  end

  def domains_by_name text
    self.domains.select{ |d| d.name == text }
  end
end
