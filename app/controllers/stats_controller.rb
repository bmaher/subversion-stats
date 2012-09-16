class StatsController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @title = "Statistics"
    @projects = Project.all
  end
end
