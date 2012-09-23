module ProjectsHelper

  YEAR = 1
  MONTH = 0

  def yearly_commits_for(model)
    model.commits.group_by { |commit| by_time_period(YEAR, commit) }
  end

  def monthly_commits_for(model)
    model.commits.group_by { |commit| by_time_period(MONTH, commit) }
  end

  def by_time_period(time_period, commit)
    case time_period
      when YEAR
        Date.parse(commit.datetime).year
      when MONTH
        Date.parse(commit.datetime).month
    end
  end

  def month_name_for(month)
    Date::MONTHNAMES[month]
  end
end
