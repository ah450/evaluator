class AddsCreatedAtIndexToResetTokens < ActiveRecord::Migration
  def change
    add_index :reset_tokens, :created_at
  end
end
