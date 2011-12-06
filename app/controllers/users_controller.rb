class UsersController < ApplicationController

  def index
    @users = User.all.paginate(:page => params[:page])
    @title = "All users"
  end

  def show
    @user = User.find(params[:id])
    @title = @user.name
  end

  def new
    @user = User.new
    @title = "Create user"
  end

  def edit
    @user = User.find(params[:id])
    @title = "Edit user"
  end

  def create
    @user = User.new(params[:user])

    if @user.save
      redirect_to @user, notice: 'User was successfully created.'
    else
      @title = "Create user"
      render action: "new"
    end
  end

  def update
    @user = User.find(params[:id])

    if @user.update_attributes(params[:user])
      redirect_to @user, notice: 'User was successfully updated.'
    else
      @title = "Edit user"
      render action: "edit"
    end
  end
end
