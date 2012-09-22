class StatsController < ApplicationController
  before_filter :authenticate_user!
  authorize_resource :class => false
  
  def index
    @title = "Statistics"
    @projects = Project.all(:include => :committers)
  end
end
