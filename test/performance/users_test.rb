require 'test_helper'
require 'rails/performance_test_help'

class UsersTest < ActionDispatch::PerformanceTest
  self.profile_options = { :runs => 4, :metrics => [:wall_time, :process_time, :cpu_time] }
  
  def test_homepage
    get '/users'
  end
  
  def test_creating_new_user
    post 'users', :post => { :body => 'Test User' }
  end
end