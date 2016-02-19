class AddsSuperUserToUsers < ActiveRecord::Migration
  def change
    add_column :users, :super_user, :boolean, null: false, default: false
  end
end
