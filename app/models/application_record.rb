##
#
##
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  protected

  ##
  #
  ##
  def debug_type_casting
    Rails.logger.debug("before: #{attributes_before_type_cast}")
    Rails.logger.debug("after: #{attributes}")
  end
end
