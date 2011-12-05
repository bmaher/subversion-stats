module CommitsHelper
  
  def changes_for(commit)
    Change.find_all_by_commit_id(commit)
  end
end
