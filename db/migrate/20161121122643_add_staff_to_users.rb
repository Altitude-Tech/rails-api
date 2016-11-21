class AddStaffToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :staff, :bool, default: false, null: false
  end
end
