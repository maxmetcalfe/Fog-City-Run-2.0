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

  # Update longest / current streak for a set of racer_ids.
  def update_streak_calendar(racer_ids)
    open_dates = []
    racers = Racer.find(racer_ids)
    for racer in racers
      open_dates = open_dates.push '2013-01-16'.to_date
      while open_dates[-1] < Date.today - 1.week
        open_dates = open_dates.push open_dates[-1].advance(:weeks => 1)
      end
      races_run = racer.results.joins(:race).map {|result| Race.find(result.race_id).date }
      longest_streak_count = 0
      streak = []
      current_streak = 0
      for o in open_dates
        found = 0
        for r in races_run
          if o == r
            streak = streak.push r
            if streak.length > longest_streak_count
              longest_streak_count = streak.length
            end
            found = 1
            if open_dates[-1] == streak[-1]
              current_streak = streak.length
            end
          end
        end
        if found == 0
          streak = []
        end
      end
      attributes = {:longest_streak => longest_streak_count,:current_streak => current_streak}
      racer.update_attributes(attributes)
    end
  end
end
