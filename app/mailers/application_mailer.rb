class ApplicationMailer > ActionMailer::Base
  default from: ENV.fetch('MAILER_FROM', "Nite Moves")
  layout 'mailer'
end