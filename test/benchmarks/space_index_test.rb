# -*- coding: utf-8 -*-
require 'benchmark'

scope do

  setup do
    User.default_client = CFoundry::Client
    login_user!
  end
  
  def visit_with_benchmark(url)
    puts Benchmark.measure {
      10.times do 
        puts "\n\n==> #{url}"
        puts Benchmark.measure { 
          visit url
          assert find('#apps-list')
          assert page.status_code == 200
        }
      end  
    }
  end  

  test 'Given I logged in when there are some apps into' + 
       ' the development space' do

    visit_with_benchmark "/spaces/development/apps" 
  end
end
