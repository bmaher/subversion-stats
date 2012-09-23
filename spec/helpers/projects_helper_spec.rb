require 'spec_helper'

describe ProjectsHelper do

  before(:each) do
    @project = FactoryGirl.create(:project)
    @committer = FactoryGirl.create(:committer, :project => @project)
    @commit = FactoryGirl.create(:commit, :project => @project, :committer => @committer)
    @project.reload
  end

  it 'should return the yearly commits for a project' do
    @old_commit = FactoryGirl.create(:commit, :project => @project,
                                :committer => @committer,
                                :datetime => '2011-01-01T00:00:00.000000A')
    @project.reload
    yearly_commits = helper.yearly_commits_for(@project)
    yearly_commits.size.should eq 2
    yearly_commits.keys.should eq [2012, 2011]
    yearly_commits.values.should eq [[@commit], [@old_commit]]
  end

  it 'should return the monthly commits for a project' do
    @new_commit = FactoryGirl.create(:commit, :project => @project,
                                     :committer => @committer,
                                     :datetime => '2012-02-01T00:00:00.000000A')
    @project.reload
    monthly_commits = helper.monthly_commits_for(@project)
    monthly_commits.size.should eq 2
    monthly_commits.keys.should eq [1, 2]
    monthly_commits.values.should eq [[@commit], [@new_commit]]
  end

  it 'should return a month name given an integer' do
    helper.month_name_for(1).should eq 'January'
  end
end