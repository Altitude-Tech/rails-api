json.data @data.each do |d|
  # device
  json.device_id(d.device_id)

  # sensor values
  json.sensor_name(d.sensor_name)
  json.call(d, :sensor_type, :sensor_data, :sensor_error)

  # other data
  json.call(d, :temperature, :pressure, :humidity, :log_time)
end
