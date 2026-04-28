# Log exceptions at the Rack level to ensure they appear in logs
# before being rescued by Rails or Bugsnag.
module FogCityRun
  class ExceptionLogger
    def initialize(app)
      @app = app
    end

    def call(env)
      @app.call(env)
    rescue => exception
      # Log the exception with request details
      begin
        request = ActionDispatch::Request.new(env)
        path = request.path
        method = request.method
        format = request.format.to_s
        uuid = request.uuid
        ip = request.remote_ip
        # Use Rails logger
        logger = Rails.logger

        # Determine if this is an API request (JSON format)
        tag = request.format.json? ? '[API] ' : ''

        # Filter sensitive parameters
        filtered_params = filter_sensitive_params(request.parameters)

        logger.error "#{tag}[RACK ERROR] #{exception.class}: #{exception.message}"
        logger.error "#{tag}  path: #{path} method: #{method} format: #{format} IP: #{ip} UUID: #{uuid}"
        logger.error "#{tag}  params: #{filtered_params.inspect}"
        logger.error "#{tag}  backtrace:\n#{exception.backtrace.join("\n")}" if exception.backtrace
      rescue => logging_error
        # If logging fails, at least log the original error with minimal context
        Rails.logger.error "[LOGGING ERROR] Failed to log exception: #{logging_error.class}: #{logging_error.message}"
        Rails.logger.error "[ORIGINAL ERROR] #{exception.class}: #{exception.message}"
      end

      # Re-raise to allow Bugsnag and Rails to handle
      raise exception
    end

    private

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
end

# Insert this middleware near the top of the stack, but after Rails' internal middleware
# that adds request UUID etc. We'll insert after ActionDispatch::RequestId.
begin
  Rails.application.config.middleware.insert_after ActionDispatch::RequestId, FogCityRun::ExceptionLogger
rescue => e
  Rails.logger.error "Failed to insert ExceptionLogger middleware: #{e.class}: #{e.message}"
  # Still try to insert at the end of the stack as a fallback
  Rails.application.config.middleware.use FogCityRun::ExceptionLogger
end