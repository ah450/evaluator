class AddsCreatedAtIndexToVerificationTokens < ActiveRecord::Migration
  def change
    add_index :verification_tokens, :created_at
  end
end
