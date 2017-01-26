##
# Customised logging formatter
##
class SenslyLoggerFormatter < Logger::Formatter
  ##
  # Sets the format of the log message
  #
  # Outputs the time, severity and message in development and production
  # Outputs the severity and message in test
  ##
  def call(severity, time, _program_name, message)
    message = message_to_s(message)

    return "[#{severity}] #{message}\n" if ENV['RAILS_ENV'] == 'test'
    return "[#{time}] [#{severity}] #{message}\n"
  end

  ##
  # Format the message object to handle non-strings being logged
  #
  # TODO: fix this, it's a string by the time it gets here
  ##
  def message_to_s(obj)
    return obj if obj.is_a?(String)
    return obj.inspect
  end
end