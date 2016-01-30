class RemoveTestTimoutSecondsFromProjects < ActiveRecord::Migration
  def change
    remove_column :projects, :test_timeout_seconds, :integer
  end
end
