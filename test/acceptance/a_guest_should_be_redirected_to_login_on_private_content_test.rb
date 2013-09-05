require_relative './acceptance_helper'

scope do
  test 'when a guest tries to access private content' do
    visit '/spaces/development/apps'
    assert has_content? 'CF Storm Login'
  end

end
