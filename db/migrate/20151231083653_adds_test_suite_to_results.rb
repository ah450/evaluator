class AddsTestSuiteToResults < ActiveRecord::Migration
  def change
    add_column :results, :test_suite_id, :integer, index: true
    add_foreign_key :results, :test_suites, column: :test_suite_id
  end
end
