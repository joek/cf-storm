class Apps < Cuba
  define do

    load_app vars[:space_name], vars[:app_name]

    on get, 'map_url' do
      res.write view('apps/map_url')
    end

    on get do
      if @app.nil?
        set_flash! "The app '#{vars[:app_name]}' does not " +
                   "exists in '#{@space.name}' space", :alert

        res.write view('shared/not-found')
      else
        load_stats_and_routes
        res.write view('apps/show')
      end
    end

    on put, param('state') do |state|
      @app.started? ? @app.stop! : @app.start!
      res.redirect space_path @space
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
