class CreateData < ActiveRecord::Migration[5.0]
  def change
    create_table :data do |t|
      t.string :sensor_type, null: false
      t.decimal :sensor_error, precision: 3, scale: 2, null: false
      t.float :sensor_data, null: false
      t.datetime :log_time, null: false
      t.references :device, foreign_key: true, null: false

      t.timestamps
    end
  end
end
