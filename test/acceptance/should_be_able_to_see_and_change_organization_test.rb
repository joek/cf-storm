scope do
  setup do
    login_user!
  end

  test 'Given I logged in I should be able to see and change my organization' do
    Capybara.ignore_hidden_elements = false
    find('#current-organization').click
    click_link 'Lolcat'
    require 'debugger'; debugger
    assert page.find('#selected-organization').value == 'Lolcat'
  end

end
