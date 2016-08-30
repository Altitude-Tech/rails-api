##
#
##

require 'validation'

##
#
##
module ParamHandler
  protected

  ##
  #
  ##
  def extract_int_param(param, default, min, max, controller = nil)
    val = params[param] || default
    Validation.validate_int(val, min, max)
  rescue ArgumentError
    controller = controller.nil? ? '' : "_#{controller}"

    msg_key = "controller.v1#{controller}.error.#{param}"
    msg = param == 'limit' ? t(msg_key, max: max) : t(msg_key)

    raise Exceptions::V1ApiError, msg
  end
end
