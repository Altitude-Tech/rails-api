##
#
##
require_relative 'boot'

require 'rails/all'
require_relative '../lib/custom_log_formatter'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Api
  ##
  #
  ##
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Don't used coloured logs
    config.colorize_logging = false

    # use UTC as time zone
    config.time_zone = 'UTC'

    # format logs to show a timestamp and severity for dev/prod
    # and just severity for test
    config.log_formatter = CustomLogFormatter.new
  end
end
