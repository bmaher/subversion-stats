module StatsHelper
  
  def committers_for(project)
    Committer.find_all_by_project_id(project)
  end
  
  def total_commits_for(committer)
    Commit.find_all_by_committer_id(committer).count
  end
  
  def commits_by(project)
    count = 0
    committers_for(project).each do |committer|
      count += total_commits_for(committer)
    end
    return count
  end
  
  def yearly_commits_for(project)
    years = Array.new
    committers_for(project).each do |committer|
      years << commits_by_year_for(committer)
    end
    years.inject{ |year, count| year.merge(count){ |key, old_value, new_value| old_value + new_value } }.to_a
  end
  
  def commits_by_year_for(committer)
    Commit.count(:conditions => "committer_id = #{committer.id}", :group => "Year(datetime)")
  end
  
  def monthly_commits_for(project)
    months = Array.new
    committers_for(project).each do |committer|
      months << commits_by_month_for(committer)
    end
    months.inject{ |months, count| months.merge(count){ |key, old_value, new_value| old_value + new_value } }.to_a
  end
  
  def commits_by_month_for(committer)
    Commit.count(:conditions => "committer_id = #{committer.id}", :group => "Month(datetime)")
  end
  
  def month_name(id)
    Date::MONTHNAMES[id]
  end
end
