class CFUser < Struct.new(:name, :email, :full_name)

  def self.test_users
    @@_users ||= [new('manuel', Settings::API_TEST_USERNAME, 'Manuel Garcia'),
                  new('lolmaster', 'lol@lol.lol', 'Lol')]

  end

  def self.add_user user
    test_users
    @@_users << user

    user
  end
  
  def organizations=(orgs)
  end  

  def add_managed_organization org
  end

  def add_billing_managed_organization org
  end

  def add_audited_organization org
  end

  def update!
    true
  end

end
