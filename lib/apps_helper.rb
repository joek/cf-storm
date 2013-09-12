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
end
