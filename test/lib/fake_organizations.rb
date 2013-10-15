class FakeOrganization < Struct.new(:name, :spaces)

  def users
    CFUser.test_users
  end

  def spaces depth=0
    FakeClient.spaces
  end

  def guid
    Digest::MD5.hexdigest self.name
  end

end
