User.default_client = ENV['INTEGRATION'] ? nil : FakeClient

prepare do
  Ohm.flush
  User.create :email => Settings::API_TEST_USERNAME
end

class FakeReq
  include UserHelpers
  include AppHelpers
  include SpaceHelpers
  include OrganizationHelpers
  include MainHelpers

  def session
    { 'current_user_id' => 1}
  end
end

class Cutest::Scope
  def session
    Capybara.current_session.driver.request.env["rack.session"]
  end

  def req
    @req ||=FakeReq.new
  end
end
