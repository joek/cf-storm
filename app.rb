require File.expand_path('shotgun',  File.dirname(__FILE__))
require File.expand_path("settings", File.dirname(__FILE__))

require 'cuba/render'

require 'uri'

Cuba.plugin Cuba::Mote
Cuba.plugin Cuba::Render
Cuba.settings[:render][:template_engine] = 'haml'

Cuba.use Rack::Session::Cookie,
  key: 'cf_storm_app',
  secret: '1aae4f5eb740067d22088604cd0dc189d'

Cuba.use Rack::Static,
  root: 'public',
  urls: ['/js', '/css', '/less', '/img']

Dir["./models/**/*.rb"].each { |rb| require rb }
Dir["./lib/**/*.rb"].each { |rb| require rb }
Dir["./helpers/**/*.rb"].each { |rb| require rb }
Dir["./routes/**/*.rb"].each { |rb| require rb }

Cuba.use Rack::Static,
  root: "public",
  urls: ["/js", "/css", "/img"]

Cuba.use Rack::Protection
Cuba.use Rack::Protection::RemoteReferrer
Cuba.plugin UserHelpers
Cuba.plugin MainHelpers
Cuba.plugin AppHelpers
Cuba.plugin SpaceHelpers
Cuba.plugin BootstrapHelpers

Ohm.connect(url: Settings::REDIS_URL)

Cuba.use Rack::MethodOverride

Cuba.define do

  on 'favicon.ico' do
  end

  on "sessions" do
    run Sessions
  end

  on "spaces" do |space|
    if current_user
      run Spaces
    else
      res.redirect '/sessions/new'
    end
  end

  on 'users' do
    if current_user
      run Users
    else
      res.redirect'/sessions/new'
    end
  end

  on get, 'async_stats/:guid' do |guid|
    app = App.rebuild(guid)
    if app.started?
      @stats = App.rebuild(guid).stats.sort_by{|key, value| key.to_i}
      res.write partial('apps/stats')
    else
      @stats = []
      res.status = 503
      res.write partial('apps/stats')
    end


  end

  on root do
    if current_user
      res.redirect root_path
    else
      res.redirect '/sessions/new'
    end
  end

  # Nothing matched the request address
  on default do
    res.write view('404')
    res.status = 404
  end

end
