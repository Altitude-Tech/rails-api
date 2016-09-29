class CreateGroups < ActiveRecord::Migration[5.0]
  def change
    create_table :groups do |t|
      t.string :name
      t.integer :admin, null: false

      t.timestamps
    end

    add_index :groups, :admin, unique: true
    add_foreign_key :groups, :users, column: :admin

    add_column :users, :group_id, :integer
    add_foreign_key :users, :groups
  end
end
