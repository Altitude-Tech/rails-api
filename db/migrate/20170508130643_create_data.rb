class CreateData < ActiveRecord::Migration[5.0]
  def change
    create_table :data do |t|
      t.integer :device_id, null: false
      t.datetime :log_time, null: false
      t.integer :gas, null: false
      t.float :conc_ppm
      t.float :conc_ugm3
    end

    add_index :data, [:device_id, :log_time, :gas], unique: true
    add_foreign_key :data, :devices
  end
end
