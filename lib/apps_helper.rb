module AppsHelper
  def app_state app
    app.started? ? 'icon-ok app-state-started icon-border' : 'icon-remove app-state-stopped icon-border'
  end
end
