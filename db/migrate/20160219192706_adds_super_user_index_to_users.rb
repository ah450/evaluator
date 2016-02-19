class AddsSuperUserIndexToUsers < ActiveRecord::Migration
  def change
    add_index :users, :super_user
  end
end
