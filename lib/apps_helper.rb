module AppsHelper
  def app_state app
    app.started? ? 'icon-ok app-state-started' : 'icon-remove app-state-stopped'
  end
end
