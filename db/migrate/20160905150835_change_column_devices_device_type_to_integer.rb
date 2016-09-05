class ChangeColumnDevicesDeviceTypeToInteger < ActiveRecord::Migration[5.0]
  def change
    change_column(:devices, :device_type, :integer)
  end
end
