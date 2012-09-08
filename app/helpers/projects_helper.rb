module ProjectsHelper
  
  def users_for(project)
    User.find_all_by_project_id(project)
  end
end
