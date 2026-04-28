class PasswordResetsController < ApplicationController
  before_action :get_user,   only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]

  include SessionsHelper

  def new
  end

  def create
    begin
      @user = User.find_by(email: params[:password_reset][:email].downcase)
      if @user
        logger.info "[PasswordReset] Creating reset digest for user: #{@user.email}"
        @user.create_reset_digest
        logger.info "[PasswordReset] Reset digest created, sending email..."
        @user.send_password_reset_email
        logger.info "[PasswordReset] Password reset email sent to: #{@user.email}"
        flash[:info] = "Email sent with password reset instructions"
        redirect_to root_url
      else
        logger.warn "[PasswordReset] Email not found: #{params[:password_reset][:email]}"
        flash.now[:danger] = "Email address not found"
        render 'new'
      end
    rescue => e
      logger.error "[PasswordReset ERROR] #{e.class}: #{e.message}"
      logger.error "[PasswordReset ERROR] Backtrace: #{e.backtrace.join("\n")}" if e.backtrace
      flash.now[:danger] = "An error occurred while processing your request. Please try again."
      render 'new'
    end
  end

  def edit
  end

  def update
    if params[:user][:password].empty?                  # Case (3)
      @user.errors.add(:password, "can't be empty")
      render 'edit'
    elsif @user.update(user_params)          # Case (4)
      log_in @user
      flash[:success] = "Password has been reset."
      redirect_to racers_path
    else
      render 'edit'                                     # Case (2)
    end
  end

  private

    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    def get_user
      @user = User.find_by(email: params[:email])
    end

    # Confirms a valid user.
    def valid_user
      unless (@user && @user.activated? &&
              @user.authenticated?(:reset, params[:id]))
        redirect_to root_url
      end
    end

    # Checks expiration of reset token.
    def check_expiration
      if @user.password_reset_expired?
        flash[:danger] = "Password reset has expired."
        redirect_to new_password_reset_url
      end
    end
end
