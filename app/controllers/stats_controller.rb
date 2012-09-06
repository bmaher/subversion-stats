class StatsController < ApplicationController
  
  def index
    @title = "Statistics"
    @users = User.all
  end
end
