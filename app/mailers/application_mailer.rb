##
#
##
class ApplicationMailer < ActionMailer::Base
  default from: 'noreply@altitude.tech'
  layout 'mailer'
end
