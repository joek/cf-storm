class Space < Struct.new(:name, :apps, :guid)
  def self.spaces_for_test
    %w(development test production).map do |s|
      new s, apps, Digest::MD5.hexdigest(s)
    end
  end

  def apps(args = nil)
    FakeClient.apps
  end

  def organization=(org)
    org
  end

  def self.apps
    FakeClient.apps
  end

  def create!
    true
  end

  def self.reset!
    @@_apps = nil
  end
end
