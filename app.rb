require File.expand_path('shotgun',  File.dirname(__FILE__))

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

Cuba.use Rack::Protection
Cuba.use Rack::Protection::RemoteReferrer

Cuba.define do
  on root do
    res.write 'hello'
  end

  on 'session' do
    on 'new' do
      res.write view('session/new')
    end
  end
end
