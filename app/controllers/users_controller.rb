class UsersController < ApplicationController

  # Show all users
  def index
    @users = User.all
  end

  # Show user by id
  def show
    @user = User.find(params[:id])
  end

  # Delete user
  def destroy
    @user = User.find(params[:id])
    @user.destroy
  end

  # Edit user
  def edit
    @user = User.find(current_user.id)
  end

  # New users
  def new
  	@user = User.new
  end

  # Create user
  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render 'new'
    end
  end

  def update
    if !params[:user].nil?
      params[:strava_link] = params[:user][:strava_link]
    end
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to root_url
    else
      render 'edit'
    end
  end

  private
  def user_params
    params.require(:user).permit(:first_name, :last_name, :password, :email, :strava_link, :racer_id)
  end
end