require_relative '../helper'


scope do

  test 'should format a number to percentage for cpu usage when is extremely small' do
    assert req.cpu_usage(2.322687459237046e-05) == '0.00%'
  end

  test 'should format a number to percentage for cpu usage when is high' do
    assert req.cpu_usage(24.566817) == '24.57%'
  end
end
