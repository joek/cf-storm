# -*- coding: utf-8 -*-
scope do

  setup do
    login_user!
  end

  test 'Given Im in the root path, I should be able to create a new space' do
    visit req.new_path(:spaces)
    
    within('#space-create-form') do 
      fill_in 'space_name', :with => 'my-crazy-space' 
      click_on 'Create'
    end
    
    assert has_content? "Space created successful"
  end

end
