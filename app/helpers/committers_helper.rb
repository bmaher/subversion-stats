module CommittersHelper
  
  def commits_for(committer)
    Commit.find_all_by_committer_id(committer)
  end
end
