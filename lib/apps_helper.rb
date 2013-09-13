module AppsHelper
  def app_state_icon_class app
    app.started? ? 'icon-ok app-state-started icon-border' :
                   'icon-remove app-state-stopped icon-border'
  end

  def app_state_class app
    app.started? ? "stop-#{app.name}" : "start-#{app.name}"
  end

  def cpu_usage number
    "%.2f%" % number
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
    "/spaces/#{space.name}/apps/#{app.name}"
  end

  def instance_status_class instance
    return 'label label-success' if instance[:state] == 'STARTED'
    return 'label label-warning' if  instance[:state] == 'RUNNING'
    return 'label label.important' if instance[:state] == 'STOPPED'
    return 'label'
  end

end
