class FakeClient
  
  Struct.new("Space", :name, :apps, :guid)
  Struct.new("App", :name, :state, :memory, :instances, :uris, :url, :guid, :total_instances)
  Struct.new("Token", :auth_header, :refresh_token)
  Struct.new("Organization", :name, :spaces)

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
  
  def apps
    @@_apps ||=
    ["Windows 8", "Win95", "DOS"].map do |a|
      Struct::App.new a, 'STARTED', 128,
       ['LOL INSTANACE', 'LOLOLOL'], ['mswin.run.io'], 'mswin.run.io', Digest::MD5.hexdigest(a), 1
    end

    @@_apps
  end
  
  def domains
    []
  end

  def self.reset!
    @@_apps = @@_spaces = nil
  end  
end
