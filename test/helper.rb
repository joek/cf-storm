User.default_client = ENV['INTEGRATION'] ? nil : FakeClient

prepare do
  Ohm.flush
  User.create :email => 'manuel.garcia@altoros.com'
end

class FakeReq
  include UserHelper
  include AppsHelper

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
