class AddsSuiteCodeToTestSuite < ActiveRecord::Migration
  def change
    add_column :test_suites, :code_id, :integer
    add_foreign_key :test_suites, :suite_codes, column: :code_id
  end
end
