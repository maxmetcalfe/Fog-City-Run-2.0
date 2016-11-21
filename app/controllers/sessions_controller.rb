class SessionsController < ApplicationController
  
  include SessionsHelper

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      if user.activated?
              log_in user
              params[:session][:remember_me] == '1' ? remember(user) : forget(user)
              redirect_back_or racers_path
            else
              message  = "Account not activated. "
              message += "Check your email for the activation link."
              flash[:warning] = message
              redirect_back_or racers_path
            end
    else
      flash[:danger] = 'Invalid email/password combination' # Not quite right!
      render 'new'
    end
  end

  def log_in(user)
    session[:user_id] = user.id
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end