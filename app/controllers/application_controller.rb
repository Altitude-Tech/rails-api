class ApplicationController < ActionController::Base
  # protect_from_forgery with: :exception

  protected
    ##
    # Validate an argument is an integer and within defined limits
    ##
    def validate_int(num, min, max)
      begin
        num = Integer(num)
      # for catching nil
      rescue TypeError => e
        raise ArgumentError, e
      end

      not_between = !!(num < min) || !!(num > max)

      raise ArgumentError, 'Number outside limits' if not_between

      return num
  end
end
