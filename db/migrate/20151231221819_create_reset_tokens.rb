class CreateResetTokens < ActiveRecord::Migration
  def change
    create_table :reset_tokens do |t|
      t.references :user, index: {:unique=>true}, foreign_key: true
      t.string :token, null: false
      t.timestamps null: false
    end
  end
end
