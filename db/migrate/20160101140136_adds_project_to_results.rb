class AddsProjectToResults < ActiveRecord::Migration
  def change
    add_column :results, :project_id, :integer, index: true
    add_foreign_key :results, :projects, column: :project_id
  end
end
