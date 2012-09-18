class ProjectsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  
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
    @project = current_user.projects.build(params[:project])

    if @project.save
      current_user.roles=current_user.roles + %w[project_owner]
      current_user.save!
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

  def destroy
    @project.destroy
    redirect_to projects_path, notice: 'Project was successfully deleted.'
  end
end
