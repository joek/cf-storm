class Apps < Cuba

  def update_with_rescue
    begin
      @app.update!
      set_flash! 'Update successful'
    rescue  CFoundry::InstancesError
      set_flash! 'Update failed', :alert
    rescue CFoundry::AppMemoryQuotaExceeded
      set_flash! "Update failed: You have exceeded your organization's memory limit", :alert
    end
  end

  def destroy_and_set_flash!
    routes = @app.routes

    if @app.delete
      routes.each{|r| r.delete}
      set_flash! "#{@app.name} destroyed"
    else
      set_flash! "#{@app.name} was not destroyed, a problem occured"
    end
  end

  def destroy_failed_and_set_flash! app_name=nil
    if app_name
      set_flash! "\"#{app_name}\" and \"#{@app.name}\"" +
        " does not match, app was not destroyed", :alert

    else
      set_flash! "No name provided for \"#{@app.name}\", " +
        "app was not destroyed", :alert
    end
    res.redirect app_path @space, @app
  end

  def build_route(url, domain)
    # TODO Review request ammounts here
    route        = current_user.route
    route.domain = current_user.domains_by_name(domain).first
    route.space  = @space
    route.host   = url
    route
  end

  def map_url_and_set_flash! url, domain
    route = build_route url, domain

    begin
      route.create!
      @app.add_route route
      set_flash! 'URL Added to the app'
    rescue CFoundry::RouteHostTaken
      set_flash! 'Route is already taken', :alert
    rescue CFoundry::RouteInvalid
      set_flash! 'Invalid URL', :alert
    end
  end

  def remove_route_and_set_flash! route_guid
    route = @app.routes.find{ |r| r.guid == route_guid }
    @app.remove_route route
    route.delete
    set_flash! 'Route unmapped successfully'
  end

  def load_stats
    @stats = @app.stopped? ? [] : @app.stats.sort_by{|key, value| key.to_i}
  end

  def load_stats_and_routes
    load_stats
    @routes = @app.routes
  end

  def redirect_to_path path
    res.redirect app_path(@space, @app) if path == 'show'
    res.redirect space_path(@space) if path == 'index'
  end

  def load_logs
    @env_log      = @app.file 'logs/env.log'
    @staging_task = @app.file 'logs/staging_task.log'
    @stderr       = @app.file 'logs/stderr.log'
    @stdout       = @app.file 'logs/stdout.log'
  end

  define do
    load_app vars[:space_name], vars[:app_name]

    on get, 'logs' do
      load_logs
      res.write view('apps/logs')
    end

    on get do
      require 'debugger'; debugger
      if @app.nil?
        set_flash! "The app '#{vars[:app_name]}' does not " +
          "exists in '#{@space.name}' space", :alert

        res.write view('shared/not-found')
      else
        load_stats_and_routes
        @service_bindings = @app.service_bindings

        # CACHE!!!!
        App.store @app
        res.write view('apps/show')
      end
    end


    on put, param('state'), param('back_to') do |state, back_to|
      @app.started? ? @app.stop! : @app.start!
      redirect_to_path back_to
      # res.redirect space_path @space
    end

    on post, param('instances') do |instances|
      @app.total_instances = instances.to_i
      update_with_rescue

      res.redirect app_path @space, @app
    end

    on post, param('url'), param('domain') do |url, domain|
      map_url_and_set_flash! url, domain
      res.redirect app_path(@space, @app)
    end

    on post, param('memory') do |memory|
      @app.memory = memory.to_i
      update_with_rescue
      res.redirect app_path @space, @app
    end

    on delete, param('app_name') do |app_name|
      if app_name == @app.name
        destroy_and_set_flash!
        res.redirect space_path @space
      else
        destroy_failed_and_set_flash! app_name
      end
    end

    on delete, param('route_guid') do |route_guid|
      remove_route_and_set_flash! route_guid
      res.redirect app_path(@space, @app)
    end

    on delete do
      destroy_failed_and_set_flash!
    end

    # Nothing matched the request address
    on default do
      res.write view('404')
      res.status = 404
    end

  end
end
