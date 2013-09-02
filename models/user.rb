class User
  extend Forwardable

  def_delegators :@client, :login

  attr_reader :client

  def initialize
    @client = CFoundry::Client.get 'http://api.run.pivotal.io'
  end

end
