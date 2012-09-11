module ProjectsHelper
  
  def committers_for(project)
    committer.find_all_by_project_id(project)
  end
end
