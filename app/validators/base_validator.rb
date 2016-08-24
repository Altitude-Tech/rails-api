##
#
##
class BaseValidator < ActiveModel::EachValidator
  ##
  #
  ##
  def validate_each(_record, _attribute, _value)
    raise NotImplementedError
  end

  protected

  ##
  # Get the raw value if it's different to the type casted value
  ##
  def get_raw_value(record, attribute, value)
    before_type_cast = "#{attribute}_before_type_cast"

    raw_value = record.send(before_type_cast) if record.respond_to?(before_type_cast)
    return value if raw_value.nil?

    Rails.logger.debug(raw_value)

    if value == raw_value
      Rails.logger.debug('no change')
      return value
    end

    Rails.logger.debug('swapping values')
    Rails.logger.debug(value)
    Rails.logger.debug(raw_value)
    return raw_value
  end
end
