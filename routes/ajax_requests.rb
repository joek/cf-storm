class AjaxRequests < Cuba
  define do
    on get, 'app/:guid/stats' do |guid|
      @app = get_app_from_cache guid
      if @app.started?
        begin
          @stats = @app.stats.sort_by{|key, value| key.to_i}
        rescue CFoundry::StatsError
          @stats = []
        end
      else
        @stats = []
        res.status = 503
      end
      @health = app_health(@app, @stats)
      res.write partial('apps/stats')
    end

    on get, 'app/:guid/env_log' do |guid|
      app = get_app_from_cache guid
      res.write truncate_log(app.file('logs/env.log'))
    end

    on get, 'app/:guid/staging_log' do |guid|
      app = get_app_from_cache guid
      res.write truncate_log(app.file('logs/staging_task.log'))
    end

    on get, 'app/:guid/stderr_log' do |guid|
      app = get_app_from_cache guid
      res.write truncate_log(app.file('logs/stderr.log'))
    end

    on get, 'app/:guid/stdout_log' do |guid|
      app = get_app_from_cache guid
      res.write truncate_log(app.file('logs/stdout.log'))
    end

    on get, 'app/:guid/service_bindings' do |guid|
      app = get_app_from_cache guid
      @service_bindings = app.service_bindings
      res.write partial('apps/services')
    end

    on get, 'app/:guid/routes' do |guid|
      @app = get_app_from_cache guid
      @routes = @app.routes
      @space = @app.space
      res.write partial('apps/uris')
    end

  end
end
