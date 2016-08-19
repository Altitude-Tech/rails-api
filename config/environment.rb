# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

# @todo revisit this, look for a better method
class Logger
  def format_message(severity, timestamp, progname, msg)
    "#{timestamp} (#{$$}) #{msg}\n"
  end
end
