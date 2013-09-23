module Settings
  File.read("env.sh").scan(/(.*?)="?(.*)"?$/).each do |key, value|
    ENV[key] ||= value
  end

  REDIS_URL = ENV["REDIS_URL"]
  HOST = ENV["APP_HOST"]
  NAME = ENV["APP_NAME"]
  API_URL = ENV['API_URL']
end
