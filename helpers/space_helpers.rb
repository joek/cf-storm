module SpaceHelpers

  def space_human_name space
    space.nil? ? "Spaces" : space.name.capitalize
  end

  def space_path(space)
    URI.escape("/spaces/#{space.name}/apps")
  end

end
