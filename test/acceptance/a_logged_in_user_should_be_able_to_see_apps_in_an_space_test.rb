scope do

  test 'Given I logged in when there are some apps into the development space' do
    login_user!
    visit '/spaces/development/apps'

    assert has_content? "development's applications"

    within('#apps-list') do
      # assert has_content? "Windows 8"
      # assert has_content? "Win95"
      # assert has_content? "DOS"
    end
  end

end
