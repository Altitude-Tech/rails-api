##
# Base model class.
##
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  protected

  ##
  # Method for debugging type casting.
  #
  # To use, add `before_validation :debug_type_casting` to a model class.
  ##
  def debug_type_casting
    Rails.logger.debug "before: #{attributes_before_type_cast}"
    Rails.logger.debug "after: #{attributes}"
  end
end
