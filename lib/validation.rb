##
#
##
module Validation
  ##
  # Check a number is an integer and within defined limits
  ##
  def self.validate_int(num, min, max)
    old = num
    num = Integer(num)

    if old.is_a?(Float)
      raise ArgumentError unless num == old
    end

    raise ArgumentError unless num.between?(min, max)

    return num
  # normalise error if nil was given as the number
  rescue TypeError => e
    raise ArgumentError, e.message
  end
end
