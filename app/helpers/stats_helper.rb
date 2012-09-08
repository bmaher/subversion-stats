module StatsHelper
  
  def total_commits_for_project(project)
    count = 0
    project.users.find_all.each do |user|
      count += total_commits_for(user)
    end
    return count
  end
  
  def total_commits_for(user)
    Commit.find_all_by_user_id(user).count
  end
  
  def commits_by_year
    Commit.count(:all, :group => "Year(datetime)")
  end
  
  def commits_by_year_for(user)
    Commit.count(:conditions => "user_id = #{user.id}", :group => "Year(datetime)")
  end
  
  def commits_by_month
    Commit.count(:all, :group => "Month(datetime)")
  end
  
  def commits_by_month_for(user)
    Commit.count(:conditions => "user_id = #{user.id}", :group => "Month(datetime)")
  end
  
  def month_name(id)
    Date::MONTHNAMES[id]
  end
end
