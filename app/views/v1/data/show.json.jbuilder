json.device do
  json.identity @device.identity
  json.type @device.device_type
  json.name @device.name
end

json.data @data do |datum|
  json.extract! datum, :sensor_type, :sensor_name, :sensor_error, :sensor_data
  json.extract! datum, :log_time, :temperature, :humidity, :pressure
end
