##
#
##
module Exceptions
  ##
  #
  ##
  class V1ApiError < StandardError
  end

  ##
  #
  ##
  class V1ApiNotFoundError
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
end
