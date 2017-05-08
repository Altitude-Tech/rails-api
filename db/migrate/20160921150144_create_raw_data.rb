class CreateRawData < ActiveRecord::Migration[5.0]
  def change
    create_table :raw_data do |t|
      t.integer :device_id, null: false
      t.integer :sensor_type, null: false
      t.float :sensor_error, null: false
      t.integer :sensor_data, null: false
      t.datetime :log_time, null: false
      t.float :temperature, null: false
      t.float :pressure, null: false
      t.float :humidity, null: false
      t.float :sensor_r0

      t.timestamps
    end

    add_index :raw_data, :device_id
    add_foreign_key :raw_data, :devices
    add_index :raw_data, [:device_id, :sensor_type, :log_time], unique: true
  end
end
