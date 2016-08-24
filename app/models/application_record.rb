##
#
##
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  protected

  def debug_type_casting
    Rails.logger.debug('before:')
    Rails.logger.debug(self.attributes)

    Rails.logger.debug('after:')
    Rails.logger.debug(self.attributes_before_type_cast)
  end
end
