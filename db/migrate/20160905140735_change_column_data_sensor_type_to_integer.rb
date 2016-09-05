class ChangeColumnDataSensorTypeToInteger < ActiveRecord::Migration[5.0]
  def change
    change_column(:data, :sensor_type, :integer)
  end
end
