require 'rspec'
require 'capybara/rspec'
require 'rack/test'
require_relative "../app"

ENV['RACK_ENV'] = 'test'

RSpec.configure do |conf|
  conf.include Rack::Test::Methods
end

def app
  Capybara.app = Cuba.app
end
