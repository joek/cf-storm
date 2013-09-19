module SpaceHelpers

  def space_human_name space
    space.nil? ? "Spaces" : space.name.capitalize
  end

  def space_path(space)
    URI.escape("/spaces/#{space.name}/apps")
  end
  
  def load_space(space_name)
    unescaped_space_name = URI.unescape space_name

    @space = current_user_spaces.find do |s|
      s.name  == URI.unescape(unescaped_space_name)
    end
  end

end
