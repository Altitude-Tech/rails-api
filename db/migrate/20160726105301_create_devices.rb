class CreateDevices < ActiveRecord::Migration[5.0]
  def change
    create_table :devices do |t|
      t.string :device_id, null: false
      t.string :device_type, null: false

      t.timestamps
    end


    add_index :devices, :device_id, unique: true
  end
end
