require 'spec_helper'
require 'cancan/matchers'

describe Ability do

  describe "admin user" do

    it "can access everything" do
      admin = Ability.new(FactoryGirl.create(:user, :roles => %w[admin]))
      admin.should be_able_to(:manage, :all)
    end
  end

  describe "basic user" do

    before(:each) do
      @basic_user = Ability.new(FactoryGirl.create(:user))
    end

    describe "can" do

      it "can view the homepage" do
        @basic_user.should be_able_to(:read, HomeController)
      end

      it "can create a new project" do
        @basic_user.should be_able_to(:create, Project)
      end
    end

    describe "cannot" do

      it "cannot see or modify project pages" do
        @basic_user.should_not be_able_to(:read, Project)
        @basic_user.should_not be_able_to(:update, Project)
        @basic_user.should_not be_able_to(:destroy, Project)
      end

      it "cannot access committer pages" do
        @basic_user.should_not be_able_to(:read, Committer)
        @basic_user.should_not be_able_to(:create, Committer)
        @basic_user.should_not be_able_to(:update, Committer)
        @basic_user.should_not be_able_to(:destroy, Committer)
      end

      it "cannot access commit pages" do
        @basic_user.should_not be_able_to(:read, Commit)
        @basic_user.should_not be_able_to(:create, Commit)
        @basic_user.should_not be_able_to(:update, Commit)
        @basic_user.should_not be_able_to(:destroy, Commit)
      end

      it "cannot access change pages" do
        @basic_user.should_not be_able_to(:read, Change)
        @basic_user.should_not be_able_to(:create, Change)
        @basic_user.should_not be_able_to(:update, Change)
        @basic_user.should_not be_able_to(:destroy, Change)
      end

      it "cannot access the stats page" do
        @basic_user.should_not be_able_to(:read, StatsController)
      end
    end
  end

  describe "project owner" do

    before(:each) do
      user = FactoryGirl.create(:user, :roles => %w[project_owner])
      @project = FactoryGirl.create(:project, :user => user)
      @other_project = FactoryGirl.create(:project, :user => user)
      @committer = FactoryGirl.create(:committer, :project => @project)
      @commit = FactoryGirl.create(:commit, :committer => @committer)
      @project_owner = Ability.new(@project.user)
    end

    describe "can" do

      it "can view the project index" do
        @project_owner.should be_able_to(:index, Project)
      end

      it "can create a new project" do
        @project_owner.should be_able_to(:create, Project)
      end

      it "can see all of its projects" do
        @project_owner.should be_able_to(:show, @project)
        @project_owner.should be_able_to(:show, @other_project)
      end

      it "can edit all of its projects" do
        @project_owner.should be_able_to(:update, @project)
        @project_owner.should be_able_to(:update, @other_project)
      end

      it "can delete all of its projects" do
        @project_owner.should be_able_to(:destroy, @project)
        @project_owner.should be_able_to(:destroy, @other_project)
      end

      it "can see all committers for its projects" do
        @committer = FactoryGirl.create(:committer, :project => @project)
        other_committer = FactoryGirl.create(:committer, :project => @other_project)
        @project_owner.should be_able_to(:show, @committer)
        @project_owner.should be_able_to(:show, other_committer)
      end

      it "can see all commits for its projects" do
        other_commit = FactoryGirl.create(:commit, :committer => @committer)
        @project_owner.should be_able_to(:show, @commit)
        @project_owner.should be_able_to(:show, other_commit)
      end

      it "can see all changes for its projects" do
        change = FactoryGirl.create(:change, :commit => @commit)
        other_change = FactoryGirl.create(:change, :commit => @commit)
        @project_owner.should be_able_to(:show, change)
        @project_owner.should be_able_to(:show, other_change)
      end
    end

    describe "cannot" do

      before(:each) do
        @other_users_project = FactoryGirl.create(:project)
      end

      it "cannot see projects that other users have created" do
        @project_owner.should_not be_able_to(:show, @other_users_project)
      end

      it "cannot edit projects that other users have created" do
        @project_owner.should_not be_able_to(:update, @other_users_project)
      end

      it "cannot delete projects that other users have created" do
        @project_owner.should_not be_able_to(:destroy, @other_users_project)
      end

      it "cannot see committers for other projects" do
        other_projects_committer = FactoryGirl.create(:committer)
        @project_owner.should_not be_able_to(:show, other_projects_committer)
      end

      it "cannot edit committers" do
        @project_owner.should_not be_able_to(:update, Committer)
      end

      it "cannot delete committers" do
        @project_owner.should_not be_able_to(:destroy, Committer)
      end

      it "cannot see commits for other projects" do
        other_projects_commit = FactoryGirl.create(:commit)
        @project_owner.should_not be_able_to(:show, other_projects_commit)
      end

      it "cannot edit commits" do
        @project_owner.should_not be_able_to(:update, Commit)
      end

      it "cannot delete commits" do
        @project_owner.should_not be_able_to(:destroy, Commit)
      end

      it "cannot see changes for other projects" do
        other_projects_change = FactoryGirl.create(:change)
        @project_owner.should_not be_able_to(:show, other_projects_change)
      end

      it "cannot edit changes" do
        @project_owner.should_not be_able_to(:update, Change)
      end

      it "cannot delete changes" do
        @project_owner.should_not be_able_to(:destroy, Change)
      end
    end
  end
end