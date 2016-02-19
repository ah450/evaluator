class FixSuiteCodesForeignKey < ActiveRecord::Migration
  def change
    remove_foreign_key 'suite_codes', 'test_suites'
    add_foreign_key 'suite_codes', 'test_suites', on_delete: :cascade
  end
end
