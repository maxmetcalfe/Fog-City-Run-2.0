class UsersController < ApplicationController

  before_filter :must_be_admin

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

  # Automatically create a new racer if there isn't an obvious existing racer for a user.
  def create_racer_for_new_user(user)
    existing_racers = Racer.where(:first_name => user.first_name, :last_name => user.last_name)
    if existing_racers.length == 0
      racer = Racer.new
      racer.id = Racer.maximum(:id).next
      racer.first_name = user.first_name
      racer.last_name = user.last_name
      racer.save
      user.update_attribute("racer_id", racer.id)
      user.save
    end
  end

  # Create user
  def create
    @user = User.new(user_params)
    if @user.save
      create_racer_for_new_user(@user)
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