##
#
##

require 'exceptions/exceptions'

module Api
  ##
  # Base API error.
  ##
  class Error < Sensly::Error
    attr_reader :code

    def initialize(message)
      @code ||= 100

      super message
    end
  end

  ##
  # Authorisation error.
  ##
  class AuthError < Error
    def initialize(message)
      @code ||= 101

      super message
    end
  end

  ##
  # Authorisation error during login.
  ##
  class LoginAuthError < Error
    def initialize(exc)
      @code ||= 102

      message = "Invalid or missing value for \"#{exc.attribute}\"."
      super message
    end
  end

  ##
  # Exception corresponding to `ActiveRecord::RecordInvalid`
  ##
  class InvalidCreateError < Error
    def initialize(exc)
      @code ||= 103

      record = exc.record
      key = record.errors.keys.first
      msg = record.errors[key].first

      message = "\"#{key}\" #{msg}."
      super message
    end
  end

  ##
  # Exception corresponding to `ActiveRecord::NotFoundError`
  ##
  class NotFoundError < Error
    def initialize(key)
      @code ||= 104

      message = "\"#{key}\" not found."
      super message
    end
  end

  ##
  # Invalid or missing value for an API parameter.
  #
  # Only thrown if the value is checked before being passed to a model.
  ##
  class ArgumentError < Error
    def initialize(key)
      @code ||= 105

      message = "Invalid argument recieved for #{key}"
      super message
    end
  end

  ##
  # Exception corresponding to `Record::GroupMemberError`.
  ##
  class GroupMemberError < Error
    def initialize(message)
      @code ||= 106

      super message
    end
  end

  ##
  # Exception corresponding to `Record::DeviceRegistrationError`.
  ##
  class DeviceRegistrationError < Error
    def initialize(message)
      @code ||= 107

      super message
    end
  end

  ##
  # Exception corresponding to `Record::DeviceAuthError`.
  ##
  class DeviceAuthError < Error
    def initialize(message)
      @code ||= 108

      super message
    end
  end

  ##
  # Exception corresponsing to `JSON::ParserError`.
  ##
  class JsonParserError < Error
    def initialize(message)
      @code ||= 109

      super message
    end
  end
end
