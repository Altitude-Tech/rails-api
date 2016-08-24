##
# Validator for log_time
##
class LogTimeValidator < BaseValidator
  ##
  #
  ##
  def validate_each(record, attribute, value)
    now = Time.now.utc
    limit = now - 30.days

    condition = (limit..now).include?(value)
  rescue NoMethodError
    condition = false
  ensure
    msg = I18n.t('validator.log_time')
    record.errors.add(attribute, msg) unless condition
  end
end
