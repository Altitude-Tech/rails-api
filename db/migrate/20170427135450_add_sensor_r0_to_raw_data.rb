class AddSensorR0ToRawData < ActiveRecord::Migration[5.0]
  def change
    add_column :raw_data, :sensor_r0, :float
  end
end
