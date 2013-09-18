module AppsHelper
  def app_state_icon_class app
    app.started? ? 'label label-success icon-ok app-state-started' :
                   'label label-inportant icon-remove app-state-stopped'
  end

  def app_state_icon app, title
    if app.started?
      "<span title=\"#{title} running\" class=\"badge badge-success app-state-started\"><i class=\"icon-ok\"></i></span>"
    else
      "<span title=\"#{title} stopped\" class=\"badge badge-important app-state-stopped\"><i class=\"icon-remove\"></i></span>"
    end
  end

  def app_label_state_class app
    app.started? ? 'label label-success' : 'label label-important'
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
    return 'label label-success' if  instance[:state] == 'RUNNING'
    return 'label label.important' if instance[:state] == 'STOPPED'
    return 'label'
  end

  def app_map_url_path space, app
    app_path(space, app) + '/map_url'
  end

  def app_health app
    "%.0f" % ((app.instances.select{ |i| i.state == 'RUNNING' }.size.to_f / app.total_instances) * 100)
  end

  def app_power_control_button_class app
    return 'btn btn-danger' if app.started?
    return 'btn btn-success'
  end

end
