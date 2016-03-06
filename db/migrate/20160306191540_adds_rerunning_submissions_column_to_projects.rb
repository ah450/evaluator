class AddsRerunningSubmissionsColumnToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :reruning_submissions, :boolean, default: false, null: false
  end
end
