OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, 'YOUR-APP-ID-HERE', 'YOUR-APP-SECRET-HERE'
end