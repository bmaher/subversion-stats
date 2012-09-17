require 'spec_helper'

describe StatsHelper do

  describe "commits by project" do

    before(:each) do
      @project = FactoryGirl.create(:project)
      committer = FactoryGirl.create(:committer, :project => @project)
      30.times { FactoryGirl.create(:commit,
                                    :revision  => FactoryGirl.generate(:revisionId),
                                    :committer => committer) }
    end

    it "should return the total number of commits in a project" do
      helper.commits_by(@project).should == 30
    end

    it "should not return commits for another project" do
      other_project = FactoryGirl.create(:project, :name => "other project")
      committer = FactoryGirl.create(:committer, :project => other_project)
      30.times { FactoryGirl.create(:commit,
                                    :revision  => FactoryGirl.generate(:revisionId),
                                    :committer => committer) }
      helper.commits_by(@project).should == 30
    end
  end

  describe "commits by month for committer" do

    before(:each) do
      @project = FactoryGirl.create(:project)
      @committer = FactoryGirl.create(:committer, :project => @project)
      10.times { FactoryGirl.create(:commit,
                                    :revision  => FactoryGirl.generate(:revisionId),
                                    :committer => @committer,
                                    :datetime  => "2012-01-01T00:00:00.000000A")}
      5.times { FactoryGirl.create(:commit,
                                    :revision  => FactoryGirl.generate(:revisionId),
                                    :committer => @committer,
                                    :datetime  => "2012-02-01T00:00:00.000000A")}
    end

    it "should return the number of commits by month" do
      helper.commits_by_month_for(@committer)[1].should == 10
      helper.commits_by_month_for(@committer)[2].should == 5
    end

    it "should not return commits for another committer" do
      other_committer = FactoryGirl.create(:committer,
                                           :project => @project,
                                           :name    => FactoryGirl.generate(:committerId))
      20.times { FactoryGirl.create(:commit,
                                    :revision  => FactoryGirl.generate(:revisionId),
                                    :committer => other_committer,
                                    :datetime  => "2012-01-01T00:00:00.000000A")}
      helper.commits_by_month_for(@committer)[1].should == 10
    end
  end

  describe "commits by year for committer" do

    before(:each) do
      @project = FactoryGirl.create(:project)
      @committer = FactoryGirl.create(:committer, :project => @project)
      10.times { FactoryGirl.create(:commit,
                                    :revision  => FactoryGirl.generate(:revisionId),
                                    :committer => @committer,
                                    :datetime  => "2012-01-01T00:00:00.000000A")}
      5.times { FactoryGirl.create(:commit,
                                    :revision  => FactoryGirl.generate(:revisionId),
                                    :committer => @committer,
                                    :datetime  => "2011-01-01T00:00:00.000000A")}
    end

    it "should return the number of commits by year" do
      helper.commits_by_year_for(@committer)[2012].should == 10
      helper.commits_by_year_for(@committer)[2011].should == 5
    end

    it "should not return commits for another committer" do
      other_committer = FactoryGirl.create(:committer,
                                           :project => @project,
                                           :name    => FactoryGirl.generate(:committerId))
      20.times { FactoryGirl.create(:commit,
                                    :revision  => FactoryGirl.generate(:revisionId),
                                    :committer => other_committer,
                                    :datetime  => "2012-01-01T00:00:00.000000A")}
      helper.commits_by_year_for(@committer)[2012].should == 10
    end
  end

  describe "committers for project" do

    before(:each) do
      @project = FactoryGirl.create(:project)
      @committer = FactoryGirl.create(:committer, :project => @project)
    end

    it "should return the committers for a project" do
      helper.committers_for(@project)[0].should == @committer
      helper.committers_for(@project)[0].id.should == @committer.id
    end
  end

  describe "month name converter" do

    it "should return a month name given an integer" do
      helper.month_name(1).should == "January"
    end
  end

  describe "monthly commits for project" do

    before(:each) do
      @project = FactoryGirl.create(:project)
      committer = FactoryGirl.create(:committer, :project => @project)
      10.times { FactoryGirl.create(:commit,
                                    :revision  => FactoryGirl.generate(:revisionId),
                                    :committer => committer,
                                    :datetime  => "2012-01-01T00:00:00.000000A")}
      5.times { FactoryGirl.create(:commit,
                                    :revision  => FactoryGirl.generate(:revisionId),
                                    :committer => committer,
                                    :datetime  => "2012-02-01T00:00:00.000000A")}
      other_committer = FactoryGirl.create(:committer, :project => @project)
      15.times { FactoryGirl.create(:commit,
                                    :revision  => FactoryGirl.generate(:revisionId),
                                    :committer => other_committer,
                                    :datetime  => "2012-01-01T00:00:00.000000A")}
      10.times { FactoryGirl.create(:commit,
                                    :revision  => FactoryGirl.generate(:revisionId),
                                    :committer => other_committer,
                                    :datetime  => "2012-02-01T00:00:00.000000A")}
    end

    it "should return the total number of commits for a project by month" do
      helper.commits_by_for(StatsHelper::MONTH, @project)[0][1].should == 25
      helper.commits_by_for(StatsHelper::MONTH, @project)[1][1].should == 15
    end
  end

  describe "total commits for committer" do

    before(:each) do
      project = FactoryGirl.create(:project)
      @committer = FactoryGirl.create(:committer, :project => project)
      30.times { FactoryGirl.create(:commit,
                                    :revision  => FactoryGirl.generate(:revisionId),
                                    :committer => @committer) }
    end

    it "should return the total number of commits for a committer" do
      helper.total_commits_for(@committer).should == 30
    end
  end

  describe "yearly commits for project" do

    before(:each) do
      @project = FactoryGirl.create(:project)
      committer = FactoryGirl.create(:committer, :project => @project)
      10.times { FactoryGirl.create(:commit,
                                    :revision  => FactoryGirl.generate(:revisionId),
                                    :committer => committer,
                                    :datetime  => "2012-01-01T00:00:00.000000A")}
      5.times { FactoryGirl.create(:commit,
                                    :revision  => FactoryGirl.generate(:revisionId),
                                    :committer => committer,
                                    :datetime  => "2011-02-01T00:00:00.000000A")}
      other_committer = FactoryGirl.create(:committer, :project => @project)
      15.times { FactoryGirl.create(:commit,
                                    :revision  => FactoryGirl.generate(:revisionId),
                                    :committer => other_committer,
                                    :datetime  => "2012-01-01T00:00:00.000000A")}
      10.times { FactoryGirl.create(:commit,
                                    :revision  => FactoryGirl.generate(:revisionId),
                                    :committer => other_committer,
                                    :datetime  => "2011-02-01T00:00:00.000000A")}
    end

    it "should return the total number of commits for a project by year" do
      helper.commits_by_for(StatsHelper::YEAR, @project)[0][1].should == 15
      helper.commits_by_for(StatsHelper::YEAR, @project)[1][1].should == 25
    end
  end
end