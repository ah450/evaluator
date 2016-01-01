class AddsSolutionToSubmission < ActiveRecord::Migration
  def change
    add_column :submissions, :solution_id, :integer
    add_foreign_key :submissions, :solutions
  end
end
