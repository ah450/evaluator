class ChangesBundleFileName < ActiveRecord::Migration
  def change
    change_column_null :project_bundles, :file_name, true
  end
end
