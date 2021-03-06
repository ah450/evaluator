class CreateProjectBundles < ActiveRecord::Migration
  def change
    create_table :project_bundles do |t|
      t.references :project, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.binary :data

      t.timestamps null: false
    end
  end
end
