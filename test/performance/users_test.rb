require 'test_helper'
require 'rails/performance_test_help'

class UsersTest < ActionDispatch::PerformanceTest
  self.profile_options = { :runs => 4, :metrics => [:wall_time, :process_time, :cpu_time] }
  
  def index_users
    get '/users'
  end
  
  def create_user
    post 'users', :post => { :body => 'Test User' }
  end
end
