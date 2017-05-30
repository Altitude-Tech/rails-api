class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :name, null: false
      t.string :password_digest, null: false
      t.boolean :staff, default: false, null: false
      t.string :session_token
      t.string :confirm_token
      t.string :reset_token

      t.timestamps
    end

    add_index :users, :email, unique: true
    add_index :users, :session_token, unique: true
    add_index :users, :confirm_token, unique: true
    add_index :users, :reset_token, unique: true
    add_foreign_key :users, :tokens, column: :session_token, primary_key: :token
    add_foreign_key :users, :tokens, column: :confirm_token, primary_key: :token
    add_foreign_key :users, :tokens, column: :reset_token, primary_key: :token
  end
end
