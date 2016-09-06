class CreateTokens < ActiveRecord::Migration[5.0]
  def change
    create_table :tokens do |t|
      t.string :token, null: false
      t.datetime :expires
      t.boolean :enabled, null: false

      t.timestamps
    end
  end
end
