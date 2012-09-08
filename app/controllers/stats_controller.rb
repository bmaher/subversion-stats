class StatsController < ApplicationController
  
  def index
    @title = "Statistics"
    @projects = Project.all
    @users = User.all
  end
end
