class CFUser < Struct.new(:name, :email, :full_name, :given_name, :family_name)

  def self.test_users
    @@_users ||= [new('manuel', Settings::API_TEST_USERNAME, 'Manuel Garcia', 'Manuel', 'garcia'),
                  new('lolmaster', 'lol@lol.lol', 'LOL', 'Master')]

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

  def add_space s
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
