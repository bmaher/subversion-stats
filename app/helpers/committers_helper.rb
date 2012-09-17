module CommittersHelper
  
  def commits_for(committer)
    committer.commits
  end
end
