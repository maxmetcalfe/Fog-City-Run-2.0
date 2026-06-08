class UsersController < ApplicationController

  before_action :must_be_admin, only: [:index, :destroy, :toggle_admin]
  before_action :correct_user_or_admin, only: [:edit, :update]

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
    redirect_to users_path
  end

  # Edit user
  def edit
    @user = User.find(params[:id])
  end

  # New users
  def new
  	@user = User.new
  end

  def correct_user_or_admin
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user == @user || current_user.admin?
  end

  # Create user
  def create
    @user = User.new(user_params)
    # Generate a temporary password if none provided (e.g. admin-created user)
    if @user.password.blank?
      temp_password = SecureRandom.hex(10)
      @user.password = temp_password
      @user.password_confirmation = temp_password
    end
    if @user.save
      begin
        @user.send_activation_email
        flash[:info] = "Please check your email to activate your account."
      rescue => e
        Rails.logger.error "[UserCreate] Email failed: #{e.class}: #{e.message}"
        flash[:warning] = "User created, but activation email failed to send."
      end
      redirect_to root_url
    else
      if current_user && current_user.admin?
        @users = User.all
        render 'index'
      else
        render 'new'
      end
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

  def toggle_admin
    @user = User.find(params[:id])
    @user.update(admin: !@user.admin?)
    redirect_back(fallback_location: users_path)
  end

  private
  def user_params
    params.require(:user).permit(:first_name, :last_name, :password, :email, :strava_link, :racer_id, :admin)
  end
end
