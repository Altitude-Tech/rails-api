# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

ActionMailer::Base.smtp_settings = {
  user_name: 'apikey',
  password: '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',
  domain: 'altitude.tech',
  address: 'smtp.sendgrid.net',
  port: 587,
  authentication: :plain,
  enable_starttls_auto: true
}
