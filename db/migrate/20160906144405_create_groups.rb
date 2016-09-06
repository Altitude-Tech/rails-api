class CreateGroups < ActiveRecord::Migration[5.0]
  def change
    create_table :groups do |t|
      t.integer :admin, null: false
      t.string :name

      t.timestamps
    end

    add_foreign_key(:groups, :users, column: :admin)
  end
end
