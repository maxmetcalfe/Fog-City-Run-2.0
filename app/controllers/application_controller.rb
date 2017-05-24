class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

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

  # Convert raw time to seconds to use in ChartKick
  def to_seconds(raw_time)
    time_split = raw_time.split(":")
    hours = time_split[0]
    minutes = time_split[1]
    seconds = time_split[2]
    return hours.to_i * 3600 + minutes.to_i * 60 + seconds.to_i
  end

  # Convert seconds to time
  def from_seconds(time_in_seconds)
    m, s = time_in_seconds.divmod(60)
    h, m = m.divmod(60)
    # Format time
    if h < 10
      h = "0" + h.to_s
    else
      h = h.to_s
    end
    if m < 10
      m = "0" + m.to_s
    else
      m = m.to_s
    end
    if s < 10
      s = "0" + s.round(1).to_s
    else
      s = s.round(1).to_s
    end
    return h + ":" + m + ":" + s
  end

  # Update the racer info
  def update_racer_info(racer_ids)
    racers = Racer.find(racer_ids)
    for r in racers
      results = Result.where(racer_id: r.id)
      r.update_attribute(:race_count, results.count)
      r.update_attribute(:fav_bib, results.includes(:race).order("races.date DESC").pluck(:bib).first)
    end
  end

  # Update longest / current streak for a set of racer_ids.
  def update_streak_calendar(racer_ids)
    open_dates = []
    racers = Racer.find(racer_ids)
    open_dates = open_dates.push '2013-01-16'.to_date
    while open_dates[-1] < Date.today - 1.week
      open_dates = open_dates.push open_dates[-1].advance(:weeks => 1)
    end
    for racer in racers
      races_run = racer.results.joins(:race).map {|result| Race.find(result.race_id).date }
      longest_streak_count = 0
      longest_streak = []
      streak = []
      current_streak = 0
      for o in open_dates
        found = 0
        for r in races_run
          if o == r
            streak = streak.push r
            if streak.length > longest_streak_count
              longest_streak_count = streak.length
              longest_streak = streak
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
    return longest_streak, streak
  end

  # Sort by group and finish time for a race.
  def validate_ranks(race_id)
    results = Result.where(:race_id => race_id)
    sorted = results.sort_by {|result| [result.group_name, result.time] }
    base = 0
    groups = []
    for r in sorted
      if !groups.include? r.group_name
        groups.push(r.group_name)
        base = 0
      end

      base += 1
      r.rank = base
      r.save
    end
  end

  # Check if the current user is registered
  def is_current_user_registered(race_id)
    if current_user and StartItem.where(:race_id => race_id).pluck(:racer_id).include? current_user.racer_id
      return true
    else
      return false
    end
  end

  private

  helper_method :current_user

end
