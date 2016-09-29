##
# Validator for datetime objects.
##
class DatetimeValidator < BaseValidator
  ##
  #
  ##
  def validate_each(record, attribute, value)
    # either nothing or an invalid timestamp was given
    if value.nil?
      raw_value = before_type_cast record, attribute

      if raw_value.nil? && options[:allow_null] == true
        return
      end

      begin
        value = Time.parse(raw_value)
      rescue ArgumentError, TypeError
        msg = 'is an invalid value'
        record.errors.add attribute, msg
        return
      end
    end

    if options.key?(:min)
      compare = options[:min] == :now ? Time.now.utc : options[:min]

      if value < compare
        msg = 'is below the minimum allowed value'
        record.errors.add attribute, msg
        return
      end
    end

    if options.key?(:max)
      compare = options[:max] == :now ? Time.now.utc : options[:max]

      if value > compare
        msg = 'is above the maximum allowed value'
        record.errors.add attribute, msg
        return
      end
    end
  end
end
