class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :log_request
  after_action :log_response



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

  def log_request
    @request_start_time = Time.now
    filtered_params = filter_sensitive_params(params)
    logger.info "[REQUEST] #{request.method} #{request.path} IP: #{request.remote_ip} UUID: #{request.uuid} params: #{filtered_params.inspect}"
  end

  def log_response
    duration = Time.now - @request_start_time
    logger.info "[RESPONSE] #{request.method} #{request.path} status: #{response.status} duration: #{duration.round(3)}s"
  end



  def filter_sensitive_params(params)
    filter = Rails.application.config.filter_parameters
    # Use ActiveSupport::ParameterFilter if available (Rails 5.1+), otherwise fall back
    if defined?(ActiveSupport::ParameterFilter)
      ActiveSupport::ParameterFilter.new(filter).filter(params)
    else
      ActionDispatch::Http::ParameterFilter.new(filter).filter(params)
    end
  end

end
