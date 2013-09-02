class User  < Ohm::Model
  extend Forwardable

  def_delegators :client, :login

  attribute :email
  index :email

  def client
    @client ||= CFoundry::Client.get 'http://api.run.pivotal.io'
  end

  def self.authenticate email, password
    user = User.find(:email => email).first

    if user.nil?
      login_and_create!(email, password)
    else
      user.login :email => email, :password => password
    end

    user
  end

  def self.login_and_create!(email, password)
    user = User.new if user.nil?
    if user.login :email => email, :password => password
      User.create :email => email
    end
  end
end
