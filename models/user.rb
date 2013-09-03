class User  < Ohm::Model
  extend Forwardable

  def_delegators :client, :login

  attribute :email
  index :email

  def client
    @client ||= CFoundry::Client.get 'http://api.run.pivotal.io'
  end

  def self.authenticate email, password
    user   = User.find(:email => email).first
    user ||= User.new :email => email

    begin
      user.login :username => email, :password => password
    rescue CFoundry::Denied
      return nil
    end

    user.save
  end

end
