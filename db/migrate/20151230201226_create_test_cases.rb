class CreateTestCases < ActiveRecord::Migration
  def change
    create_table :test_cases do |t|
      t.references :result, index: true, foreign_key: true
      t.string :name, null: false
      t.text :detail
      t.text :java_klass_name
      t.boolean :passed, null: false
      t.integer :grade, null: false
      t.integer :max_grade, null: false
      t.timestamps null: false
    end
  end
end
