class ProjectsController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @projects = Project.all.paginate(:page => params[:page])
    @title = "All projects"
  end
  
  def show
    @project = Project.find(params[:id])
    @title = @project.name
  end
  
  def new
    @project = Project.new
    @title = "Create project"
  end
  
  def create
    @project = Project.new(params[:project])

    if @project.save
      redirect_to @project, notice: 'Project was successfully created.'
    else
      @title = "Create project"
      render action: "new"
    end
  end
  
  def edit
    @project = Project.find(params[:id])
    @title = "Edit project"
  end
  
  def update
    @project = Project.find(params[:id])

    if @project.update_attributes(params[:project])
      redirect_to @project, notice: 'Project was successfully updated.'
    else
      @title = "Edit project  "
      render action: "edit"
    end
  end
end
