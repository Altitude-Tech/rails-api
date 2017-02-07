class AddUniqueToData < ActiveRecord::Migration[5.0]
  def change
    add_index :data, [:device_id, :sensor_type, :log_time], unique: true
  end
end
