class StatsController < ApplicationController
  
  def index
    @title = "Statistics"
    @projects = Project.all
  end
end
