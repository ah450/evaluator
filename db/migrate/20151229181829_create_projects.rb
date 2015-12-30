class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.datetime :due_date, null: false
      t.string :name, null: false
      t.references :course, index: true, foreign_key: true
      t.integer :test_timeout_seconds, null: false, default: 600
      t.boolean :quiz, default: false, null: false
      t.boolean :published, default: false, null: false
      t.boolean :ready, default: false, null: false
      t.timestamps null: false
    end
    add_index :projects, :name
    add_index :projects, :quiz
    add_index :projects, :published
    add_index :projects, :ready
  end
end
