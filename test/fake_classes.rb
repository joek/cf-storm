class FakeClient

  Struct.new("Space", :name, :apps, :guid)
  Struct.new("App", :name, :state, :memory, :instances, :uris, :url, :guid,
                    :total_instances)
  Struct.new("Token", :auth_header, :refresh_token)
  Struct.new("Organization", :name, :spaces)
  Struct.new('Domain', :name)
  Struct.new('Route', :domain, :space, :host)


  class Struct::Route
    def create!
      # TODO Check self.host is valid (regex o algo)
      # TODO Add check to throw takken exception
      true
    end
  end

  class Struct::App
    def started?
      self.state == 'STARTED'
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
                       ['LOL INSTANACE', 'LOLOLOL'], #instances
                       ['mswin.run.io'],  #uris
                       'mswin.run.io',    #url
                       Digest::MD5.hexdigest(a),  #guid
                       1 #total_instances
    end

    @@_apps
  end

  def self.reset!
    @@_apps = @@_spaces = nil
  end

  def domains
    @@_domains ||= [Struct::Domain.new('lolmaster.com'), Struct::Domain.new('mailinator.com')]

    @@_domains
  end

  def route
    Struct::Route.new
  end

  def domains_by_name text
    self.domains.find{ |d| d.name == text }
  end
end
