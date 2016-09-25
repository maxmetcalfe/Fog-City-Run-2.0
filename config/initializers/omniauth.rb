OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '678283658991535', '330d4ab8e7df5f542ad8427824d20e30'
end
