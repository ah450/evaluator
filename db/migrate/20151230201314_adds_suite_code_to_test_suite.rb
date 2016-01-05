class AddsSuiteCodeToTestSuite < ActiveRecord::Migration
  def change
    add_column :test_suites, :suite_code_id, :integer
    add_foreign_key :test_suites, :suite_codes, column: :suite_code_id
  end
end
