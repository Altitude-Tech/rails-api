class CreateData < ActiveRecord::Migration[5.0]
  def change
    create_table :data do |t|
      t.integer :device_id, null: false
      t.integer :sensor_type, null: false
      t.float :sensor_error, null: false
      t.integer :sensor_data, null: false
      t.datetime :log_time, null: false
      t.float :temperature, null: false
      t.float :pressure, null: false
      t.float :humidity, null: false

      t.timestamps
    end

    add_index :data, :device_id
    add_foreign_key :data, :devices
  end
end
