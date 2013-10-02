class Organization < Struct.new(:name, :spaces)

  def users
    CFUser.test_users
  end

end
