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

  test 'should return 100 health percentage of app' do
    assert req.app_health(@app) == '100'
  end

  test 'should return 50 health percentage of app when half of its instances are running' do
    @app.half_health_with_two_instances!
    assert req.app_health(@app) == '50'

    @app.half_health_with_four_instances!
    assert req.app_health(@app)
  end

  test 'should return 25 health percentage of app when one out of four instances is running' do
    @app.quarter_health!
    assert req.app_health(@app) == '25'
  end

  test 'should return 0 health when no instances are running' do
    @app.zero_health!
    assert req.app_health(@app) == '0'
  end

  test 'should return integer number of health' do
    @app.one_out_of_three_instances_running!
    assert req.app_health(@app) == '33'
  end

end
