Struct.new("App", :name, :state, :memory, :stats, :url, :guid)

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
    self.stats = {}
    self.stats["0"] = custom_stat('RUNNING')
    self.stats["1"] = custom_stat('DOWN')
  end

  def half_health_with_four_instances!
    self.stats = {}
    self.stats["0"] = custom_stat('RUNNING')
    self.stats["1"] = custom_stat('RUNNING')
    self.stats["2"] = custom_stat('DOWN')
    self.stats["3"] = custom_stat('DOWN')
  end

  def quarter_health!
    self.stats = {}
    self.stats["0"] = custom_stat('RUNNING')
    self.stats["1"] = custom_stat('DOWN')
    self.stats["2"] = custom_stat('DOWN')
    self.stats["3"] = custom_stat('DOWN')
  end

  def zero_health!
    self.stats = {}
    self.stats["0"] = custom_stat('DOWN')
  end

  def one_out_of_three_instances_running!
    self.stats = {}
    self.stats["0"] = custom_stat('RUNNING')
    self.stats["1"] = custom_stat('DOWN')
    self.stats["2"] = custom_stat('DOWN')
  end

  def full_health!
    self.stats = {}
    self.stats["0"] = custom_stat('RUNNING')
  end

  def total_instances
    @instances_count = self.stats.size
  end

  def total_instances= value
    @instances_count = value
  end
end
