scope do
  setup do
    login_user!
  end

  test 'I see the organizations list' do
    with_hidden_elements do
      within('#organization-menu') do
        assert has_content? current_user.organizations.first.name
      end
    end
  end
end
