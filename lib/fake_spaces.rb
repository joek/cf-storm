Struct.new("Space", :name, :apps, :guid)

class Struct::Space
  def organization=(org)
    org
  end

  def create!
    true
  end
end
