module StatsHelper

  YEAR = 0
  MONTH = 1

  def commits_by_for(time_range, project)
    range = Array.new
    project.committers.each do |committer|
      case time_range
        when YEAR
          range << commits_by_year_for(committer)
        when MONTH
          range << commits_by_month_for(committer)
      end
    end
    range.inject { |memo, count| memo.merge(count){ |key, old_value, new_value| old_value + new_value } }.to_a
  end
  
  def commits_by_year_for(committer)
    Commit.count(:conditions => "committer_id = #{committer.id}", :group => "Year(datetime)")
  end
  
  def commits_by_month_for(committer)
    Commit.count(:conditions => "committer_id = #{committer.id}", :group => "Month(datetime)")
  end
  
  def month_name(id)
    Date::MONTHNAMES[id]
  end
end
