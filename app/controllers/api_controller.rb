class ApiController < BaseApiController
	def index
		if params.key? :help
			render plain: 'help'
			return
		end

		render json: params

	end

	def create
		begin
			format_log_time
		rescue KeyError, ArgumentError
			# let it be caught below
		end

		begin
			check_for_device
		rescue KeyError => e
			logger.debug(e.message)
			render plain: "#{e.message}", status: :bad_request
			return
		# <http://www.rubydoc.info/docs/rails/4.1.7/ActiveRecord/RecordInvalid>
		rescue ActiveRecord::RecordInvalid => e
			logger.debug(e.message)
			render plain: "#{e.message}", status: :bad_request
			return
		end

		begin
			insert_to_db
		rescue KeyError => e
			render plain: 'Key not found: DATA (Data).', status: :bad_request
			return
		rescue ActiveRecord::RecordInvalid => e
			render plain: "#{e.message}", status: :bad_request
			return
		end

		render plain: 'Data inserted successfully.'
	end

	private
		def format_log_time
			# use this to catch out any non-integers
			log_time = Integer(@json.fetch('LOG_TIME'))
			# convert unix time to sql datetime format
			@json['LOG_TIME'] = Time.at(log_time).to_s(:db)
		end

		def check_for_device
			device_data = {}

			# add these separate into the hash to improve error response
			begin
				device_data[:device_id] = @json.fetch('DID')
			rescue KeyError
				raise KeyError.new('Key not found: DID (Device id).')
			end

			begin
				device_data[:device_type] = @json.fetch('DYPE')
			rescue KeyError
				raise KeyError.new('Key not found: DYPE (Device type).')
			end

			begin
				# check both id and type match
				# to make sure either/both being invalid is caught correctly
				@device = Device.find_by!(**device_data)

			# @todo remove when user table is set up
			rescue ActiveRecord::RecordNotFound
				# attempt to insert instead
				@device = Device.create!(**device_data)
			end
		end

		def insert_to_db
			data = @json.fetch('DATA')

			data = data.map {|k, v| [k.downcase, v]}.to_h
			data = data.symbolize_keys
			data[:log_time] = @json['LOG_TIME']
			data[:device_id] = @device.id

			# logger.debug(data)

			Datum.create!(**data)
		end
end