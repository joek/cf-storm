require_relative '../helper'

scope do
  setup do
    @space = FakeClient.new.spaces.first
  end
  test 'Should return humanized name for space' do
    assert req.space_human_name(@space) == @space.name.capitalize
  end

  test 'should return space url' do
    assert req.space_path(@space) == "/spaces/#{@space.name}/apps"
  end

end
