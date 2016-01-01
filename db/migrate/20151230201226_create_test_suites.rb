class CreateTestSuites < ActiveRecord::Migration
  def change
    create_table :test_suites do |t|
      t.references :project, index: true, foreign_key: true
      t.boolean :private, index: true, null: false
      t.boolean :ready, null: false, default: false
      t.string :name, null: false
      t.timestamps null: false
    end
  end
end
