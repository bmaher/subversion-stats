require 'test_helper'
require 'rails/performance_test_help'

class CommittersTest < ActionDispatch::PerformanceTest
  self.profile_options = { :runs => 4, :metrics => [:wall_time, :process_time, :cpu_time] }
  
  def test_homepage
    get '/committers'
  end
  
  def test_creating_new_committer
    post 'committers', :post => { :body => 'Test committer' }
  end
end