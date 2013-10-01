module UserHelpers

  def current_user
    @current_user ||= User[session['current_user_id']]
  end

  def current_user_spaces
    @spaces ||= current_user.spaces(:depth => 0) if current_user
  end
  
  def load_app(space_name, app_name) 
    unescaped_app_name = URI.unescape(app_name)
    load_space space_name
    @app = @apps.find{ |a| a.name == unescaped_app_name }
  end
  
  def load_space(space_name)
    unescaped_space_name = URI.unescape space_name

    @space ||= current_user_spaces.find do |s|
      s.name  == URI.unescape(unescaped_space_name)
    end

    @apps ||= @space.apps(:depth => 0) unless @space.nil?
    @space
  end

  def session
    req.session
  end

  def user_avatar_path(user, size=30)
    "http://www.gravatar.com/avatar/#{user.avatar_file}?s=#{size}"
  end
  
  
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
  
  def load_stats_and_routes
    @stats     = @app.stopped? ? [] : @app.stats.sort
    @routes    = @app.routes
  end
end
