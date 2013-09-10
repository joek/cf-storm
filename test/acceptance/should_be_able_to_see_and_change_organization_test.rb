scope do
  setup do
    login_user!
    load_default_organization
  end

  test 'Given I logged in I should be able to see and change my organization' do
    Capybara.ignore_hidden_elements = false
    find('#current-organization').click
    # require 'debugger' ; debugger
    click_button @organization.name
    assert find('#current-organization').text == @organization.name

    Capybara.ignore_hidden_elements = true
  end

end
