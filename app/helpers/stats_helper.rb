module StatsHelper
  
  def total_commits_for(user)
    Commit.find_all_by_user_id(user).count
  end
end
