class CommittersController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource

  def index
    @committers = Committer.all.paginate(:page => params[:page])
    @title = "All committers"
  end

  def show
    @committer = Committer.find(params[:id])
    @title = @committer.name
  end

  def new
    @committer = Committer.new
    @title = "Create committer"
  end

  def edit
    @committer = Committer.find(params[:id])
    @title = "Edit committer"
  end

  def create
    @committer = Committer.new(params[:committer])

    if @committer.save
      redirect_to @committer, notice: 'committer was successfully created.'
    else
      @title = "Create committer"
      render action: "new"
    end
  end

  def update
    @committer = Committer.find(params[:id])

    if @committer.update_attributes(params[:committer])
      redirect_to @committer, notice: 'committer was successfully updated.'
    else
      @title = "Edit committer"
      render action: "edit"
    end
  end
end
