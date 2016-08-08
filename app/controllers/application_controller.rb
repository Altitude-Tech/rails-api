class ApplicationController < ActionController::Base
	# protect_from_forgery with: :exception

	protected
		# validate an argument is an integer and within defined limits
		def validate_int(num, min, max)
			begin
				num = Integer(num)
			# for catching nil
			rescue TypeError => e
				raise ArgumentError.new(e)
			end

			if num < min || num > max
				raise ArgumentError.new('Number outside limits')
			end

			return num
		end
end
