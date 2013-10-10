class Organization < Struct.new(:name, :spaces)

  def users
    CFUser.test_users
  end

  def spaces depth=0
    FakeClient.spaces
  end

end
