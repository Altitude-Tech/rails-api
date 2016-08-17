class AddColumnsToData < ActiveRecord::Migration[5.0]
  def change
    add_column :data, :temperature, :float, null: false
    add_column :data, :pressure, :float, null: false
    add_column :data, :humidity, :float, null: false
  end
end
