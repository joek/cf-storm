class User  < Ohm::Model
  extend Forwardable

  def_delegators :@client, :login

  attribute :email

  def client
    @client ||= CFoundry::Client.get 'http://api.run.pivotal.io'
  end

end
