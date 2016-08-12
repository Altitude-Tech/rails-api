class DevicesController < ApplicationController
	before_action :set_json

	def index
		limit = params['limit'] || 10
		start = params['start'] || 1

		begin
			limit = validate_int limit, 1, 500
		rescue ArgumentError
			return_error t(:devices_error_limit, max: 500)
			return
		end

		begin
			start = validate_int start, 1, Float::INFINITY
		rescue ArgumentError
			return_error t(:devices_error_start)
			return
		end

		@devices = Device.where('id >= ?', start).order('id').limit(limit)

		logger.debug(@devices.count)

		if !@devices.any?
			return_error t(:devices_no_more)
			return
		end
	end

	def show
		begin
			# look up by device_id rather than id (primary key in the database)
			# as it's the indentification people are more likely to have
			@device = Device.find_by! device_id: params[:id]
		rescue ActiveRecord::RecordNotFound
			return_error t(:devices_not_found)
			return
		end
	end

	private
		def set_json
			request.format = :json
		end

		def return_error(msg)
			error_json = { :error => msg }
			render :json => error_json, status: :bad_request
		end
end