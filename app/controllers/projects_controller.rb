class ProjectsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  
  def index
    @projects = Project.all.paginate(:page => params[:page])
    @title = "All projects"
  end
  
  def show
    @project = Project.find(params[:id], :include => {:committers => :commits})
    @title = @project.name
  end
  
  def new
    @project = Project.new
    @title = "Create project"
  end
  
  def create
    @project = current_user.projects.build(params[:project])

    if @project.save
      message = 'Project was successfully created.'
      unless @project.log_file.blank?
        ImportWorker.perform_async(@project.id, @project.log_file.read)
        message = 'Project is being imported.'
      end
      current_user.roles=current_user.roles + %w[project_owner]
      current_user.save!
      redirect_to @project, notice: message
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
      message = 'Project was successfully updated.'
      unless @project.log_file.blank?
        ImportWorker.perform_async(@project.id, @project.log_file.read)
        message = 'Project is being updated.'
      end
      redirect_to @project, notice: message
    else
      @title = "Edit project  "
      render action: "edit"
    end
  end

  def destroy
    DeleteProjectWorker.perform_async(@project.id)
    redirect_to projects_path, notice: 'Project is being deleted.'
  end
end
