class UAA
  def change_password guid, new, old
    return { :status => :ok }
  end


  def user guid
    { :emails => [{:value => Settings::API_TEST_USERNAME}], :name => { :givenname => Settings::API_TEST_USERNAME, :family => Settings::API_TEST_USERNAME}}
  end

end
