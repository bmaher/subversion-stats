require 'LogImporter'

class UploadsController < ApplicationController

  def new
    @title = "Upload Log"
    @upload = Upload.new
  end

  def create
    @upload = Upload.new(params[:upload])
    
    if @upload.valid?
      import_log
      redirect_to projects_path, :notice => 'Project is being imported.'
    else
      @title = "Upload Log"
      render action: "new"
    end
  end
  
  def import_log
    @project_name = @upload.project_name    
    
    create_project
    
    if project_created?
      importer = LogImporter.new(@project, @upload.log_file)
      importer.import
    end
  end
  
  def create_project
    @project = Project.new(:name => @project_name)
  end
  
  def project_created?
    @project.save ? true : false
  end
end