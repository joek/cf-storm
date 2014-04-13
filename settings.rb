require 'json'

module Settings
  File.read("env.sh").scan(/(.*?)="?(.*)"?$/).each do |key, value|
    ENV[key] ||= value
  end

  HOST = ENV['APP_HOST']
  NAME = ENV['APP_NAME']
  API_URL = ENV['API_URL']
  API_TEST_USERNAME = ENV['API_TEST_USERNAME']
  API_TEST_PASSWORD = ENV['API_TEST_PASSWORD']

  REDIS_URL = ENV["REDIS_URL"]

end
