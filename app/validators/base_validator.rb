##
#
##
class BaseValidator < ActiveModel::EachValidator
  protected

  ##
  # Get the value of `attribute` before it was type cast
  ##
  def before_type_cast(record, attribute)
    before_attr = "#{attribute}_before_type_cast"
    raw_value = record.send before_attr if record.respond_to? before_attr

    return raw_value
  end
end
