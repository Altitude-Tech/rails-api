json.data @data.each do |d|
  json.call(d, :sensor_data, :sensor_error, :sensor_type, :log_time,
            :device_id, :temperature, :pressure, :humidity)
  json.sensor_name(d.sensor_name)
end
