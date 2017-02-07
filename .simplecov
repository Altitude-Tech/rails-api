##
# SimpleCov config
##

SimpleCov.start 'rails' do
  add_filter "app/assets"
  add_filter "app/channels"
  add_filter "app/jobs"
  # TODO: Remove this
  add_filter "app/mailers"
end
