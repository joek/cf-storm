class Organization < Struct.new(:name, :spaces)

  Struct.new("User", :name, :email, :full_name)

  def users
    [Struct::User.new('manuel', Settings::API_TEST_USERNAME, 'Manuel Garcia'),
     Struct::User.new('lolmaster', 'lol@lol.lol', 'Lol')]
  end

end
