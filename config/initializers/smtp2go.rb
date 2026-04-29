# Custom delivery method for SMTP2GO REST API
# Autoloaded from lib/smtp2go_delivery.rb

ActionMailer::Base.add_delivery_method(:smtp2go, Smtp2goDelivery)
