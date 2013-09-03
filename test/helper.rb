require_relative "../app"

################################
# In order to sandbox the test and dev env, we declare a
# different value for REDIS_URL when doing tests.
ENV["REDIS_URL"] ||= "redis://localhost:6379/13"

require "cuba/test"
require 'cuba/capybara'

prepare do
  Capybara.reset!
  Ohm.flush
  User.create :email => 'manuel.garcia@altoros.com'
end

class Cutest::Scope
  def session
    Capybara.current_session.driver.request.env["rack.session"]
  end
end
