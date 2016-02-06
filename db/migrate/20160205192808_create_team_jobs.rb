class CreateTeamJobs < ActiveRecord::Migration
  def change
    create_table :team_jobs do |t|
      t.references :user, index: true, foreign_key: true
      t.binary :data
      t.timestamps null: false
    end
  end
end
