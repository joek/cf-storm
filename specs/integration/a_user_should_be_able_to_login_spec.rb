require 'capybara/rspec'

require 'rspec'
require 'rack/test'
require_relative "../../app"

RSpec.configure do |conf|
  conf.include Rack::Test::Methods

end

ENV['RACK_ENV'] = 'test'

describe "A user should be able to login" , :type => :feature do

  before do
    Capybara.app = Cuba.app
  end

  context "when credentials are ok" do

    it "logins the user" do
      visit '/sessions/new'
      within("#session") do
        fill_in 'Login', :with => 'an@example.com'
        fill_in 'Password', :with => 'password'
      end

      click_link 'Sign in'
      expect(page).to have_content 'Success'
    end
  end

end
