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

class FakeClient
  def login(credentials)
    true
  end

  def info
    {:description => "Cloud Foundry sponsored by Pivotal"}
  end

  def self.get(target)
    new
  end
end

class FakeClientLoginFail < FakeClient
  def login(credentials)
    raise CFoundry::Denied
  end
end

User.default_client = FakeClient
