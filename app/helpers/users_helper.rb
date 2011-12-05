module UsersHelper
  
  def commits_for(user)
    Commit.find_all_by_user_id(user)
  end
end
