# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

# @todo revisit this, look for a better method
class Logger
  def format_message(_severity, timestamp, _progname, msg)
    "#{timestamp} (#{$PID}) #{msg}\n"
  end
end
