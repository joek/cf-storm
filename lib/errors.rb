class PasswordMissmatch < Exception
  def initialize(msg=nil)
    @message = msg || 'Password does not match  password confirmation'
  end

  def message
    @message
  end
end
