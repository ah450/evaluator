class FixTeamJobForeignKeyConstraint < ActiveRecord::Migration
  def change
    remove_foreign_key 'team_jobs', 'users'
    add_foreign_key 'team_jobs', 'users', on_delete: :cascade
  end
end
