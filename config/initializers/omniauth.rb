OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '1013683108730693', '75216b928ca28618a63893a86da2c801'
end