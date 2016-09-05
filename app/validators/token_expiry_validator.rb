##
# Validator for log_time
##
class TokenExpiryValidator < BaseValidator
  ##
  #
  ##
  def validate_each(record, attribute, value)
    puts value.inspect
    # nil indicates the token shouldn't expire based on a time
    return if value.nil?

    msg = I18n.t('validator.token_expires_invalid')
    record.errors.add(attribute, msg) unless value <= Time.now.utc
  end
end
