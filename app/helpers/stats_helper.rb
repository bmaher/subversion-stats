module StatsHelper
  
  def users_for_project(project)
    project.users.find_all
  end
  
  def total_commits_for(user)
    Commit.find_all_by_user_id(user).count
  end
  
  def commits_by_project(project)
    count = 0
    users_for_project(project).each do |user|
      count += total_commits_for(user)
    end
    return count
  end
  
  def commits_by_year_for_project(project)
    years = Array.new
    users_for_project(project).each do |user|
      years << commits_by_year_for(user)
    end
    years.inject{ |year, count| year.merge(count){ |key, old_value, new_value| old_value + new_value } }.to_a
  end
  
  def commits_by_year_for(user)
    Commit.count(:conditions => "user_id = #{user.id}", :group => "Year(datetime)")
  end
  
  def commits_by_month_for_project(project)
    months = Array.new
    users_for_project(project).each do |user|
      months << commits_by_month_for(user)
    end
    months.inject{ |months, count| months.merge(count){ |key, old_value, new_value| old_value + new_value } }.to_a
  end
  
  def commits_by_month_for(user)
    Commit.count(:conditions => "user_id = #{user.id}", :group => "Month(datetime)")
  end
  
  def month_name(id)
    Date::MONTHNAMES[id]
  end
end
