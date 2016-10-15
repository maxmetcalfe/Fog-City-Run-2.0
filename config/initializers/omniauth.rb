OmniAuth.config.logger = Rails.logger

PROD_FACEBOOK_APP_ID = '1013683108730693'
PROD_FACEBOOK_APP_SECRET = '75216b928ca28618a63893a86da2c801'

DEV_FACEBOOK_APP_ID = '678283658991535'
DEV_FACEBOOK_APP_SECRET = '330d4ab8e7df5f542ad8427824d20e30'

if Rails.env.production?
  Rails.application.config.middleware.use OmniAuth::Builder do
    provider :facebook, PROD_FACEBOOK_APP_ID, PROD_FACEBOOK_APP_SECRET
  end
elsif Rails.env.development?
  Rails.application.config.middleware.use OmniAuth::Builder do
    provider :facebook, DEV_FACEBOOK_APP_ID, DEV_FACEBOOK_APP_SECRET
  end
end