class CreateDevices < ActiveRecord::Migration[5.0]
  def change
    create_table :devices do |t|
      t.string :identity, null: false
      t.integer :device_type, null: false
      t.string :token
      t.integer :group_id

      t.timestamps
    end

    add_index :devices, :identity, unique: true
    add_index :devices, :token, unique: true
    add_foreign_key :devices, :tokens, column: :token, primary_key: :token
    add_foreign_key :devices, :groups
  end
end
