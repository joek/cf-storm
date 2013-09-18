class FakeClient

  Struct.new("Space", :name, :apps, :guid)
  Struct.new("App", :name, :state, :memory, :instances, :url, :guid)
  Struct.new("Token", :auth_header, :refresh_token)
  Struct.new("Organization", :name, :spaces)
  Struct.new('Domain', :name)
  Struct.new('Route', :domain, :space, :host, :guid)
  Struct.new('Instance', :state)

  class Struct::Space

    def organization=(org)
      org
    end
  end

  class Struct::Space

    def create!
      true
    end
  end

  class Struct::Route
    def create!
      # TODO Check self.host is valid (regex o algo)
      # TODO Add check to throw takken exception
      true
    end

    def name
      [self.host, self.domain.name].join('.')
    end
  end

  class Struct::App
    def started?
      self.state == 'STARTED'
    end

    def stopped?
      self.state == 'STOPPED'
    end

    def stop!
      self.state = 'STOPPED'
    end

    def start!
      self.state = 'STARTED'
    end

    def delete
      FakeClient.apps.delete_if{|a| a.name == self.name}
    end

    def update!
      raise CFoundry::InstancesError if self.total_instances > 10
      raise CFoundry::AppMemoryQuotaExceeded if self.memory > 1024
      return true
    end

    def stats
      {"0" => {:state => "RUNNING", :stats => {
            :uptime => 111,
            :mem_quota => 134217728,
            :disk_quota => 1073741824,
            :usage => {:time => "2013-09-12 14:58:33 +0000",
              :cpu => 2.2491581771068845e-05,
              :mem => 19628032,
              :disk => 55828480}}}}
    end

    def add_route route
      if self.uris.include? [route.host, route.domain.name].join('.')
        raise CFoundry::RouteHostTaken
      end
      @@_routes << route
    end

    def remove_route route
      self.routes.delete_if{ |r| r.guid == route.guid}
    end

    def routes
      @@_routes ||=
        [Struct::Route.new(Struct::Domain.new('mswin.com'), nil, 'run.io', Digest::MD5.hexdigest('mswin'))]

      @@_routes
    end

    def uris
      self.routes.collect{ |r| [r.host, r.domain.name].join('.') }
    end

    def reset_routes!
      @@_routes = nil
    end

    def half_health_with_two_instances!
      self.instances = [Struct::Instance.new('RUNNING'), Struct::Instance.new('DOWN')]
    end

    def half_health_with_four_instances!
      self.instances = [Struct::Instance.new('RUNNING'),
                        Struct::Instance.new('DOWN'),
                        Struct::Instance.new('RUNNING'),
                        Struct::Instance.new('DOWN'),]
    end

    def quarter_health!
      self.instances = [Struct::Instance.new('RUNNING'),
                        Struct::Instance.new('DOWN'),
                        Struct::Instance.new('DOWN'),
                        Struct::Instance.new('DOWN'),]
    end

    def zero_health!
      self.instances = [Struct::Instance.new('DOWN')]
    end

    def one_out_of_three_instances_running!
      self.instances = [Struct::Instance.new('RUNNING'),
                        Struct::Instance.new('DOWN'),
                        Struct::Instance.new('DOWN')]
    end

    def total_instances
      self.instances.size
    end
  end


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
                       [Struct::Instance.new('RUNNING'), Struct::Instance.new('RUNNING')], #instances
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
