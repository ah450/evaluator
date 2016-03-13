class DropsTeamGrades < ActiveRecord::Migration
  def change
    drop_table :team_grades
  end
end
