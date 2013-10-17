class CFUser < Struct.new(:email)

  def self.test_users
    @@_users ||= [new(Settings::API_TEST_USERNAME),
                  new('lol@lol.lol')]

  end

  def self.add_user user
    test_users
    @@_users << user

    user
  end

  def organizations=(orgs)
  end

  def organizations
  end

  def add_managed_organization org
  end

  def add_billing_managed_organization org
  end

  def add_audited_organization org
  end

  def add_space s
  end

  def given_name
  end

  def family_name
  end


  def update!
    true
  end

  def guid
    Digest::MD5.hexdigest self.email
  end

  def delete
    @@_users.delete_if{ |u| u.guid == self.guid }
    true
  end

end
