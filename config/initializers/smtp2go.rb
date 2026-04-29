# Custom delivery method for SMTP2GO REST API
require Rails.root.join('lib/smtp2go_delivery')

ActionMailer::Base.add_delivery_method(:smtp2go, Smtp2goDelivery)
