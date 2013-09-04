class FakeClient

  Struct.new("Space", :name, :apps)
  Struct.new("App", :name)
  Struct.new("Token", :auth_header, :refresh_token)

  def login(credentials)
    valid_usernames = ['manuel.garcia@altoros.com']
    if valid_usernames.include? credentials[:username]
      Struct::Token.new "my-auth-token", "my-refresh-token"
    else
      raise CFoundry::Denied
    end

  end

  def info
    {:description => "Cloud Foundry sponsored by Pivotal"}
  end

  def self.get(target, token = nil)
    new
  end

  def spaces
    %w(development test production).map do |s|
      Struct::Space.new s, apps
    end
  end

  def apps
    ["Windows 8", "Win95", "DOS"].map do |a|
      Struct::App.new a
    end
  end
end
