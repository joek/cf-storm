Struct.new('Route', :domain, :space, :host, :guid)

class Struct::Route
  def create!
    # TODO Check self.host is valid (regex o algo)
    # TODO Add check to throw takken exception
    true
  end

  def name
    [self.host, self.domain.name].join('.')
  end
end
