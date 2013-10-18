module AppHelpers
  def app_state_icon_class app
    app.started? ? "#{label('success')} #{icon('ok')} app-state-started" :
                   "#{label('danger')} #{icon('ok')} app-state-stopped"
  end

  def app_state_icon app, title
    if app.started?
      "<span title=\"#{title} running\" class=\"#{badge('success')} app-state-started\"><i class=\"icon-ok\"></i></span>"
    else
      "<span title=\"#{title} stopped\" class=\"#{bs.badge('important')} app-state-stopped\"><i class=\"icon-remove\"></i></span>"
    end
  end

  def app_label_state_class app
    app.started? ? label('success') : label('danger')
  end

  def app_state_class app
    app.started? ? "stop-#{app.name}" : "start-#{app.name}"
  end

  def cpu_usage number
    "%.2f%" % (number * 100)
  end

  def to_megabytes bytes
    mega_bytes = (bytes / 1024.0) / 1024.0
    "%.2f MB" % mega_bytes
  end

  def human_time seconds
    days       = seconds / 86400
    remaining  = seconds % 86400
    "#{days} days #{Time.at(remaining).gmtime.strftime('%R:%S')}"
  end

  def app_path space, app
    URI.escape("/spaces/#{space.name}/apps/#{app.name}")
  end

  def app_logs_path space, app
    app_path(space, app) + '/logs'
  end

  def instance_status_class instance
    return label('default') if instance[:state] == 'STARTED'
    return label('success') if  instance[:state] == 'RUNNING'
    return label('danger') if instance[:state] == 'STOPPED'
    return label('default')
  end

  def app_map_url_path space, app
    app_path(space, app) + '/map_url'
  end

  def app_health app, stats
    if stats
      "%.0f" % ((running_instances(stats) / app.total_instances.to_f) * 100)
    else
      '0'
    end

  end

  def running_instances(stats)
    stats.map{|k,v| v}.select{|s| s[:state] == "RUNNING"}.size
  end

  def app_power_control_button_class app
    return 'btn btn-danger' if app.started?
    return 'btn btn-success'
  end

  def cache_app app
    App.store app
  end

  def get_app_from_cache guid
    App.rebuild(guid)
  end

  def truncate_log log, lines=100
    max = log.split("\n").size
    min = max - lines
    min = 0 if min < 0
    log.split("\n")[min..max].join("<br />")
  end

  def app_async_request guid, resource
    "/async/app/#{guid}/#{resource}"
  end
end
