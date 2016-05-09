class ChangesBundleSizeType < ActiveRecord::Migration
  def change
    change_column :project_bundles, :size_bytes, :bigint
  end
end
