class SessionsController < ApplicationController
  
  include SessionsHelper

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      if user.activated?
              log_in user
              params[:session][:remember_me] == '1' ? remember(user) : forget(user)
              redirect_to racers_path
            else
              message  = "Account not activated. "
              message += "Check your email for the activation link."
              flash[:warning] = message
              redirect_to racers_path
            end
    else
      flash[:danger] = 'Invalid email/password combination' # Not quite right!
      render 'new'
    end
  end
end