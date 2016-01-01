class AddsNameProjectIndexToTeamGrade < ActiveRecord::Migration
  def change
    add_index :team_grades, [:name, :project_id]
  end
end
