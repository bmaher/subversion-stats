class Ability
  include CanCan::Ability

  def initialize(user)
    @user = user || User.new
    @user.roles.each { |role| send(role) }

    if @user.roles.size == 0
      can :read, HomeController
      project_creator
    end
  end

  def admin
    can :manage, :all
  end

  def project_creator
    can :create, Project
  end

  def project_owner
    project_creator

    can :index, Project

    can [:show, :update, :destroy], Project, :user_id => @user.id

    can :show, Committer, :project_id do |committer|
      Project.find(committer.project_id).user.id == @user.id
    end

    can :show, Commit, :committer_id do |commit|
      Committer.find(commit.committer_id).project.user.id == @user.id
    end

    can :show, Change, :commit_id do |change|
      Commit.find(change.commit_id).committer.project.user.id == @user.id
    end
  end
end
