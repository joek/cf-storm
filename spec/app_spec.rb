require_relative 'helper'

describe 'App' do
  describe 'session' do
    describe 'new' do
      it 'should respond to get' do
        get 'sessions/new'
        last_response.should be_ok
        last_response.body.should match(/Login with your cf user:/)
      end
    end
  end
end
