class ChangeProjectBundleToDiskStorage < ActiveRecord::Migration
  def change
    execute('DELETE FROM project_bundles')
    remove_column :project_bundles, :data
    add_column :project_bundles, :file_name, :string, null: false
  end
end
