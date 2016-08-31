class CreateTokens < ActiveRecord::Migration[5.0]
  def change
    create_table :tokens do |t|
      t.string :public_key, null: false
      t.string :private_key, null: false
      t.datetime :expires, null: false
      t.boolean :valid, null: false

      t.timestamps
    end
  end
end
