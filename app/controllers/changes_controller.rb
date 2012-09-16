class ChangesController < ApplicationController
  before_filter :authenticate_admin!

  def index
    @changes = Change.all.paginate(:page => params[:page])
    @title = "All changes"
  end

  def show
    @change = Change.find(params[:id])
    @title = "Change #{@change.fullpath}"
  end

  def new
    @change = Change.new
    @title = "Create change"
  end

  def edit
    @change = Change.find(params[:id])
    @title = "Edit change"
  end

  def create
    @change = Change.new(params[:change])

    if @change.save
      redirect_to @change, notice: 'Change was successfully created.'
    else
      @title = "Create change"
      render action: "new"
    end
  end

  def update
    @change = Change.find(params[:id])

    if @change.update_attributes(params[:change])
      redirect_to @change, notice: 'Change was successfully updated.'
    else
      @title = "Edit change"
      render action: "edit"
    end
  end
end