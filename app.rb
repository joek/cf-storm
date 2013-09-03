require File.expand_path('shotgun',  File.dirname(__FILE__))
require File.expand_path("settings", File.dirname(__FILE__))

require 'cuba/render'

Cuba.plugin Cuba::Mote
Cuba.plugin Cuba::Render
Cuba.settings[:render][:template_engine] = 'haml'

Cuba.use Rack::Session::Cookie,
  key: '__insert app name__',
  secret: '__insert secret here__'

Cuba.use Rack::Static,
  root: 'public',
  urls: ['/js', '/css', '/less', '/img']

Dir["./models/**/*.rb"].each { |rb| require rb }
Dir["./lib/**/*.rb"].each { |rb| require rb }
Dir["./routes/**/*.rb"].each { |rb| require rb }

Cuba.use Rack::Protection
Cuba.use Rack::Protection::RemoteReferrer
Cuba.plugin UserHelper

Ohm.connect(url: Settings::REDIS_URL)


Cuba.define do

  on "sessions" do
    run Sessions
  end

  on "apps" do
    on get do
      res.write view('apps/index')
    end
  end

end
