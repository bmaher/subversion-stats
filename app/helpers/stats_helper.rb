module StatsHelper
  
  def total_commits_for(user)
    Commit.find_all_by_user_id(user).count
  end
  
  def commits_by_year
    Commit.count(:all, :group => "Year(datetime)")
  end
end
