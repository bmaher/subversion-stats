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

      unless @project.repository_url.blank?
        fetch_and_import_log_file
        set_message CREATE
      end
      unless @project.log_file.blank?
        import_log_file
        set_message CREATE
      end

      current_user.roles = current_user.roles + %w[project_owner]
      current_user.save!

      redirect_to @project, :notice => @message ||= 'Project was successfully created.'
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

      unless @project.repository_url.blank?
        fetch_and_import_log_file
        set_message UPDATE
      end
      unless @project.log_file.blank?
        import_log_file
        set_message UPDATE
      end

      redirect_to @project, :notice => @message ||= 'Project was successfully updated.'
    else
      @title = "Edit project"
      render action: "edit"
    end
  end

  def destroy
    DeleteProjectWorker.perform_async(@project.id)
    redirect_to projects_path, :notice => 'Project is being deleted.'
  end

  private

  def import_log_file
    ImportWorker.perform_async(@project.id, @project.log_file.read)
  end

  def fetch_and_import_log_file
    repository_details = { :repository_url => @project.repository_url,
                           :username => @project.username,
                           :password => @project.password,
                           :revision_from => @project.revision_from,
                           :revision_to => @project.revision_to }
    FetchWorker.perform_async(@project.id, repository_details)
  end

  CREATE = 0
  UPDATE = 1
  def set_message(action_type)
    case action_type
      when CREATE
        @message = 'Project is being imported.'
      when UPDATE
        @message = 'Project is being updated.'
      else
        @message = nil
    end
  end
end
