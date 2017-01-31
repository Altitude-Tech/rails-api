class RenameDataToRawData < ActiveRecord::Migration[5.0]
  def change
    rename_table :data, :raw_data
  end
end
