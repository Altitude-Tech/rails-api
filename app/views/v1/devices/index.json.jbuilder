json.devices @devices.each do |device|
  json.call(device, :device_id, :device_type)
  json.device_name(device.name)
end
