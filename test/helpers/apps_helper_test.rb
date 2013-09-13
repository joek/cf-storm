require_relative '../helper'


scope do

  test 'should format a number to percentage for cpu usage when is extremely small' do
    assert req.cpu_usage(2.322687459237046e-05) == '0.00%'
  end

  test 'should format a number to percentage for cpu usage when is high' do
    assert req.cpu_usage(24.566817) == '24.57%'
  end

  test 'should humanize memory amount' do
    assert req.to_megabytes(19628032) == '18.72 MB'
  end

  test 'should convert seconds in days hours:mins:secs' do
    assert req.human_time(17288000) == '200 days 02:13:20'
  end

  test 'should return app path' do
    @space = FakeClient.new.spaces.first
    @app = @space.apps.first
    assert req.app_path(@space, @app) == "/spaces/#{@space.name}/apps/#{@app.name}"
  end

end
