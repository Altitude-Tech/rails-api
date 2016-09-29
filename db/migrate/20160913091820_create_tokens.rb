class CreateTokens < ActiveRecord::Migration[5.0]
  def change
    create_table :tokens, id: false do |t|
      t.string :token, null: false
      t.datetime :expires
      t.boolean :enabled, null: false, default: true

      t.timestamps
    end

    add_index :tokens, :token, unique: true
  end
end
