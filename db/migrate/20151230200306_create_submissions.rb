class CreateSubmissions < ActiveRecord::Migration
  def change
    create_table :submissions do |t|
      t.references :project, index: true, foreign_key: true
      t.integer :student_id, index: true
      t.timestamps null: false
    end
    add_foreign_key :submissions, :users, column: :student_id
  end
end
