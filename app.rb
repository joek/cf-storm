require File.expand_path('shotgun',  File.dirname(__FILE__))
require File.expand_path("settings", File.dirname(__FILE__))
require 'redic/pool'

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
Cuba.plugin OrganizationHelpers
Cuba.plugin BootstrapHelpers

Ohm.redis = Redic::Pool.new(Settings::REDIS_URL, size: Settings::REDIS_CONNECTION_POOL_SIZE)

Cuba.use Rack::MethodOverride

# ugly fix for marshal
class OpenSSL::SSL::SSLContext
  def _dump_data
  end
  def _load_data *args
  end
end

# Test mode
# Dir["./test/lib/**/*.rb"].each { |rb| require rb }
# User.default_client = FakeClient

Cuba.define do

  on 'favicon.ico' do
  end

  on "sessions" do
    run Sessions
  end

  on "organizations/:organization_name" do |org|
    if current_user
      with :organization_name => org do
        run Organizations
      end
    else
      res.redirect '/sessions/new'
    end
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

  on get, 'async' do
    run AjaxRequests
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
