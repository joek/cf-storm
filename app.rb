require File.expand_path("shotgun",  File.dirname(__FILE__))

Cuba.plugin Cuba::Mote

Cuba.use Rack::Session::Cookie,
  key: "__insert app name__",
  secret: "__insert secret here__"

Cuba.use Rack::Static,
  root: "public",
  urls: ["/js", "/css", "/less", "/img"]

Cuba.use Rack::Protection
Cuba.use Rack::Protection::RemoteReferrer

Dir["./lib/**/*.rb"].each     { |rb| require rb }
Dir["./models/**/*.rb"].each  { |rb| require rb }
Dir["./routes/**/*.rb"].each  { |rb| require rb }

Cuba.define do
  on root do
    res.write "hello"
  end
end
