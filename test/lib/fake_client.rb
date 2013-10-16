require 'ostruct'

class FakeClient < OpenStruct

  # Generic Structs
  Struct.new("Token", :auth_header, :refresh_token)
  # Struct.new("Organization", :name, :spaces, :users)
  Struct.new('Domain', :name)
  Struct.new('Instance', :state)
  Struct.new('ServiceBinding', :service_instance, :manifest)
  Struct.new('ServiceInstance', :name, :dashboard_url, :service_plan)
  Struct.new('ServicePlan', :name, :description)

  def login(credentials)
    valid_usernames = [Settings::API_TEST_USERNAME]
    if valid_usernames.include? credentials[:username]
      token = Struct::Token.new "my-auth-token", "my-refresh-token"
      self.current_user = CFUser.new 'test_user', credentials[:username], 'My User',
                                'My'
    else
      raise CFoundry::Denied
    end
    token
  end

  def current_user
    @@_current_user
  end

  def current_user= user
    @@_current_user = user
  end

  def self.check_valid_endpoint! endpoint
    valid_endpoints = [Settings::API_URL, 'custom_api.cf.com', 'not_a_cf']
    unless valid_endpoints.include? endpoint
      raise CFoundry::InvalidTarget.new(endpoint)
    end
    if endpoint == 'not_a_cf'
      raise CFoundry::TargetRefused.new(endpoint)
    end
  end

  def register email, password
    CFUser.add_user CFUser.new(nil, email, nil)
  end

  def info
    {:description => "Cloud Foundry sponsored by Pivotal"}
  end

  def self.get(target, token = nil)
    check_valid_endpoint! target
    new :target => target
  end

  def token
    Struct::Token.new "my-auth-token", "my-refresh-token"
  end

  def current_organization
    nil
  end

  def organizations
    [FakeOrganization.new("Acme", [spaces])]
  end

  def space
    Space.new '', ''
  end

  def self.spaces
    @@_spaces
  end

  def spaces(args = nil)
    @@_spaces ||= Space.spaces_for_test

    @@_spaces
  end

  def self.apps
    @@_apps ||= FakeApp.apps_for_test
  end

  def apps
    FakeClient.apps
  end

  def self.reset!
    @@_apps = @@_spaces = nil
    Space.reset!
  end

  def domains depth=0
    @@_domains ||= [Struct::Domain.new('lolmaster.com'), Struct::Domain.new('run.io')]

    @@_domains
  end

  def route
    Route.new
  end

  def domains_by_name text
    self.domains.select{ |d| d.name == text }
  end
end
