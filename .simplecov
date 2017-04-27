##
# SimpleCov config
##

SimpleCov.start 'rails' do
  add_filter "app/assets"
  add_filter "app/jobs"
  # incorrectly claims it does nothing
  add_filter "lib/logger/sensly_logger_formatter.rb"
  # TODO: Remove this
  add_filter "app/mailers"
end
