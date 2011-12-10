require 'test_helper'
require 'rails/performance_test_help'

class HomepageTest < ActionDispatch::PerformanceTest
  self.profile_options = { :runs => 4, :metrics => [:wall_time, :process_time, :cpu_time] }

  def test_homepage
    get '/'
  end
end