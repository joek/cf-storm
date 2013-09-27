class Route < Struct.new(:domain, :space, :host, :guid)
  def create!
    # TODO Check self.host is valid (regex o algo)
    # TODO Add check to throw takken exception
    true
  end
  
  def delete 
    true
  end  

  def name
    [self.host, self.domain.name].join('.')
  end
end
