class AddSessionTokenToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column(:users, :session_token, :integer, index: true)
    add_foreign_key(:users, :tokens, column: :session_token)
  end
end
