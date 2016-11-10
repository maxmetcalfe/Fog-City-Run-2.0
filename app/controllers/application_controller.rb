class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user

  # Calculate new race counts
  def update_race_count()
    @racers = Racer.all
    for r in @racers
      race_count = Result.where(racer_id: r.id).count
      r.update_attribute(:race_count, race_count)
    end
  end
 
end
