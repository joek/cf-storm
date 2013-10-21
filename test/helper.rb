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
    if Capybara.current_driver == :rack_test
      Capybara.current_session.driver.request.env["rack.session"]
    elsif Capybara.current_driver == :selenium
      decode_cookie Capybara.current_session.driver.browser.manage.all_cookies.first[:value]
    else
      decode_cookie Capybara.current_session.driver.browser.get_cookies.first.gsub(/\Acf_storm_app=/, '').gsub(/\A([^;]*)/).first
    end
  end

  def req
    @req ||=FakeReq.new
  end

  private
  def decode_cookie cookie
    Marshal.load(Base64.decode64(CGI.unescape(cookie.split("\n").join).split('--').first))
  end
end
