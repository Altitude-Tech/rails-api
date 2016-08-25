##
#
##
class CustomLogFormatter < Logger::Formatter
  ##
  #
  ##
  def call(severity, time, program_name, message)
    return "[#{severity}] #{message}\n" if ENV['RAILS_ENV'] == 'test'
    return "[#{time}] [#{severity}] #{message}\n"
  end
end
