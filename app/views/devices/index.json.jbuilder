logger.debug(@devices)
json.devices @devices.each do |device|
  logger.debug(device)
  json.call(device, :device_id, :device_type)
end
