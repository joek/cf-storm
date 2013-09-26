# -*- coding: utf-8 -*-
scope do

  setup do
    login_user!
  end

  # Context: Visiting root path
  test 'I create a valid space' do
    visit req.new_path(:spaces)
    
    within('#space-create-form') do 
      fill_in 'space_name', :with => 'my-crazy-space' 
      click_on 'Create'
    end
    
    assert has_content? "Space created successful"
  end

end
