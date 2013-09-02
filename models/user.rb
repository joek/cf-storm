class User  < Ohm::Model
  extend Forwardable

  def_delegators :client, :login

  attribute :email
  index :email

  def client
    @client ||= CFoundry::Client.get 'http://api.run.pivotal.io'
  end

  def self.authenticate email, password
    puts User.all.first.inspect
    user = User.find(:email => email).first
    user.client.login :email => email, :password => password
    user
  end

end
