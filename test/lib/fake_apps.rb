class FakeApp < Struct.new(:name, :state, :memory, :stats, :url, :guid)
  def self.apps_for_test
    ["Windows 8", "Win95", "DOS"].map do |a|
      self.new a, #name
      'STARTED',         #state
      128,               #memory
      {},                #stats
      'mswin.run.io',    #url
      Digest::MD5.hexdigest(a)  #guid
    end

  end

  def service_bindings
    plan = Struct::ServicePlan.new('lolPlan', 'Lol lol lol lol')
    service_instance = Struct::ServiceInstance.new('lol-service', 'lolcat.com', plan)
    manifest = { :entity => { :credentials => { :port => 1, :hostname => 'lol.com.ar', :password => '1234' } } }
    [Struct::ServiceBinding.new(service_instance, manifest)]
  end

  def space
    FakeClient.spaces.first
  end

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
    raise CFoundry::InstancesError if @instances_count > 10
    raise CFoundry::AppMemoryQuotaExceeded if self.memory > 1024
    return true
  end

  def custom_stat state = 'RUNNING'
    {:state =>  state, :stats => {
        :uptime => 111,
        :mem_quota => 134217728,
        :disk_quota => 1073741824,
        :usage => {:time => "2013-09-12 14:58:33 +0000",
          :cpu => 2.2491581771068845e-05,
          :mem => 19628032,
          :disk => 55828480}}}
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
      [Route.new(Struct::Domain.new('mswin.com'), nil, 'run.io', Digest::MD5.hexdigest('mswin'))]

    @@_routes
  end

  def uris
    self.routes.collect{ |r| [r.host, r.domain.name].join('.') }
  end

  def reset_routes!
    @@_routes = nil
  end

  def health_with(up, down)
    self.stats = {}

    up.times do |t|
      self.stats[t.to_s] = custom_stat 'RUNNING'
    end

    down.times do |t|
      self.stats[(up + t).to_s] = custom_stat 'DOWN'
    end
  end

  def total_instances
    @instances_count = self.stats.size
  end

  def total_instances= value
    @instances_count = value
  end
end
