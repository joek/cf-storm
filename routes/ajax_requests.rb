class AjaxRequests < Cuba
  define do
    on get, 'app/:guid/stats' do |guid|
      app = get_app_from_cache guid
      if app.started?
        @stats = App.rebuild(guid).stats.sort_by{|key, value| key.to_i}
        res.write partial('apps/stats')
      else
        @stats = []
        res.status = 503
        res.write partial('apps/stats')
      end
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

  end
end
