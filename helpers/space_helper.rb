module SpaceHelper

  def space_human_name space
    space.nil? ? "Spaces" : space.name.capitalize
  end
end
