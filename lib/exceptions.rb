##
#
##
module Exceptions
  ##
  # Base Exception
  ##
  class SenslyError < StandardError
  end

  ##
  # Base API Exception
  ##
  class ApiError < SenslyError
  end

  ##
  # Base Model Exception
  ##
  class ModelError < SenslyError
  end

  ##
  #
  ##
  class UserError < ModelError
  end

  ##
  #
  ##
  class GroupError < ModelError
  end

  ##
  #
  ##
  class GroupInGroupError < GroupError
  end

  ##
  #
  ##
  class UserPasswordDigestError < UserError
  end

  ##
  #
  ##
  class UserAuthenticationError < UserError
  end

  ##
  #
  ##
  class UserUpdateError < UserError
  end

  ##
  # Base API Exception for Api v1
  ##
  class V1ApiError < ApiError
  end

  ##
  #
  ##
  class V1ApiNotFoundError < V1ApiError
    attr_reader :model, :id, :primary_key, :key, :value

    ##
    #
    ##
    def initialize(exc, key, value)
      # attrs exposed by ActiveRecord::RecordNotFound
      @model = exc.model
      @id = exc.id
      @primary_key = exc.primary_key
      # additional attrs to expose
      @key = key
      @value = value

      super(exc.message)
    end
  end

  ##
  #
  ##
  class V1ApiRecordInvalid < V1ApiError
  end

  ##
  #
  ##
  class V1ApiInvalidSessionError < V1ApiError
  end

  ##
  #
  ##
  class V1ApiUnauthorisedError < V1ApiError
  end

  ##
  #
  ##
  class V1ApiInvalidSessionError < V1ApiError
  end
end
