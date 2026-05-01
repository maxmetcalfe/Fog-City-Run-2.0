Bugsnag.configure do |config|
  config.api_key = "8f8e3e326697b09dc7196a52a9ba4147"
  config.logger = Rails.logger
  # Optionally set the app version for release tracking
  config.app_version = ENV['HEROKU_RELEASE_VERSION'] if ENV['HEROKU_RELEASE_VERSION']
  # Ensure we capture errors in all environments
  config.notify_release_stages = ['production', 'staging', 'development']
end
