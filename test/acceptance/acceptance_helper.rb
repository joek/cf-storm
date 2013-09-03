require_relative '../helper'

if ENV['INTEGRATION']
  User.default_client = nil
  puts " ==> Running with #{User.api_url}"
end
