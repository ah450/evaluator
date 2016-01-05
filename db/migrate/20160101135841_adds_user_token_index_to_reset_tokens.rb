class AddsUserTokenIndexToResetTokens < ActiveRecord::Migration
  def change
    add_index :reset_tokens, [:user_id, :token]
  end
end
