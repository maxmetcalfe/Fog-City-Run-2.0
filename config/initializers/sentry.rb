Sentry.init do |config|
  config.dsn = ENV['SENTRY_DSN']
  config.environment = Rails.env

  # Breadcrumbs configuration
  config.breadcrumbs_logger = [:active_support_logger, :http_logger]

  # Only enable in production
  config.enabled_environments = %w[production]

  # Sampling
  config.traces_sample_rate = 0.5
  config.profiles_sample_rate = 0.1

  # Release tracking
  config.release = ENV['HEROKU_SLUG_COMMIT'] if ENV['HEROKU_SLUG_COMMIT']

  # Send default PII (disable if you want to be more cautious)
  config.send_default_pii = false

  # Before send hook to filter sensitive data
  config.before_send = lambda do |event, _hint|
    event
  end
end
