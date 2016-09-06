class AddIndexToTokensToken < ActiveRecord::Migration[5.0]
  def change
    add_index(:tokens, :token, unique: true)
  end
end
