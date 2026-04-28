class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :log_request
  after_action :log_response

  # Global error handling to ensure all exceptions are logged and sent to error tracking
  # Using StandardError instead of Exception to avoid catching system-level errors
  rescue_from StandardError, with: :handle_exception

  def handle_exception(exception)
    # Prevent infinite recursion
    if request.env['fogcityrun.exception_handled']
      raise exception
    end
    
    # Mark as handled and store in request env
    request.env['fogcityrun.exception_handled'] = true
    
    # Get request details safely
    path = request.path rescue 'unknown'
    method = request.method rescue 'unknown'
    
    # Log to Rails logger (goes to Heroku logs)
    logger.error "[GLOBAL ERROR] #{exception.class}: #{exception.message}"
    logger.error "[GLOBAL ERROR] path: #{path} method: #{method}"
    if exception.backtrace
      logger.error "[GLOBAL ERROR] backtrace:\n#{exception.backtrace.join("\n")}"
    end
    
    # Also output to stdout for Heroku (ensures visibility)
    puts "[GLOBAL ERROR] #{exception.class}: #{exception.message}"
    puts "[GLOBAL ERROR] path: #{path} method: #{method}"
    
    # Notify Bugsnag
    if defined?(Bugsnag)
      begin
        Bugsnag.notify(exception)
      rescue => e
        logger.error "[BUGSNAG ERROR] Failed to notify: #{e.class}: #{e.message}"
      end
    end
    
    # Re-raise to allow Rails default error handling (500 page, etc.)
    raise exception
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
    begin
      @request_start_time = Time.now
      filtered_params = filter_sensitive_params(params)
      logger.info "[REQUEST] #{request.method} #{request.path} IP: #{request.remote_ip} UUID: #{request.uuid} params: #{filtered_params.inspect}"
    rescue => e
      logger.error "[LOG_REQUEST ERROR] #{e.class}: #{e.message}"
      @request_start_time = Time.now # still set it for log_response
    end
  end

  def log_response
    begin
      duration = @request_start_time ? Time.now - @request_start_time : 0
      logger.info "[RESPONSE] #{request.method} #{request.path} status: #{response.status} duration: #{duration.round(3)}s"
    rescue => e
      logger.error "[LOG_RESPONSE ERROR] #{e.class}: #{e.message}"
    end
  end



  def filter_sensitive_params(params)
    filter = Rails.application.config.filter_parameters
    # Convert ActionController::Parameters to hash for filtering
    params_hash = if params.respond_to?(:to_unsafe_h)
                    params.to_unsafe_h
                  elsif params.respond_to?(:to_h)
                    params.to_h
                  else
                    params
                  end
    
    # Use ActiveSupport::ParameterFilter if available (Rails 5.1+), otherwise fall back
    if defined?(ActiveSupport::ParameterFilter)
      ActiveSupport::ParameterFilter.new(filter).filter(params_hash)
    else
      ActionDispatch::Http::ParameterFilter.new(filter).filter(params_hash)
    end
  end

end
