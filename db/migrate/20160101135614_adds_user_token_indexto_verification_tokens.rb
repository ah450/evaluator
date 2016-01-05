class AddsUserTokenIndextoVerificationTokens < ActiveRecord::Migration
  def change
    add_index :verification_tokens, [:user_id, :token]
  end
end
