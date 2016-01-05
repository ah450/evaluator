class CreateTeamGrades < ActiveRecord::Migration
  def change
    create_table :team_grades do |t|
      t.string :name, null: false
      t.references :project, index: true, foreign_key: true
      t.boolean :private, null: false
      t.references :result, index: true, foreign_key: true
      t.timestamps null: false
    end
    add_index :team_grades, [:name, :project_id]
  end
end
