class CommitsController < ApplicationController

  def index
    @commits = Commit.all.paginate(:page => params[:page])
    @title = "All commits"
  end

  def show
    @commit = Commit.find(params[:id])
    @title = "Revision #{@commit.revision.to_s}"
  end

  def new
    @commit = Commit.new
    @title = "Create commit"
  end

  def edit
    @commit = Commit.find(params[:id])
    @title = "Edit commit"
  end

  def create
    @commit = Commit.new(params[:commit])

    if @commit.save
      redirect_to @commit, notice: 'Commit was successfully created.'
    else
      @title = "Create commit"
      render action: "new"
    end
  end

  def update
    @commit = Commit.find(params[:id])

    if @commit.update_attributes(params[:commit])
      redirect_to @commit, notice: 'Commit was successfully updated.'
    else
      @title = "Edit commit"
      render action: "edit"
    end
  end
end