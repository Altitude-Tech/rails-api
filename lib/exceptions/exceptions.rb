##
#
##

module Sensly
  ##
  # Base error class.
  ##
  class Error < StandardError
  end

  ##
  # To be used to handle behaviour that should be possible.
  ##
  class UnknownError < Error
  end
end
