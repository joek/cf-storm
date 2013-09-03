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

Cuba.use Rack::Protection
Cuba.use Rack::Protection::RemoteReferrer
Cuba.plugin UserHelper

Ohm.connect(url: Settings::REDIS_URL)


Cuba.define do

  on get do

    on "apps" do
      res.write view('apps/index')
    end

    on 'sessions' do
      on 'new' do
        res.write view('session/new')
      end
    end

  end

  on post do
    on 'sessions' do
      on param("email"), param("password") do |email, password|
        @user = User.authenticate email, password
        session['current_user_id'] = @user.id

        res.redirect "/apps"
      end
    end
  end

end
