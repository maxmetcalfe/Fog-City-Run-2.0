class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def log_in(user)
    session[:user_id] = user.id
  end

  def must_be_admin
    unless current_user && current_user.admin?
      redirect_to root_path
    end
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def current_racer
    @current_racer = Racer.find(current_user.racer_id)
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

  # Continue timing a result by toggling the start item, found by racer_id and racer_id.
  def continue_time
    result = Result.find(params[:id])
    start_item = StartItem.where(:race_id=>result.race_id).where(:racer_id=>result.racer_id)[0]
    race = Race.find(start_item.race_id)
    start_item.finished = false
    start_item.save
    result.destroy
    redirect_to race
  end

  private

  helper_method :current_user
  helper_method :current_racer

end
