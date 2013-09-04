################################
# In order to sandbox the test and dev env, we declare a
# different value for REDIS_URL when doing tests.
ENV["REDIS_URL"] ||= "redis://localhost:6379/13"

prepare do
  Ohm.flush
  User.create :email => 'manuel.garcia@altoros.com'
end

class Cutest::Scope
  def session
    Capybara.current_session.driver.request.env["rack.session"]
  end
end

require_relative 'fake_classes'

User.default_client = FakeClient
