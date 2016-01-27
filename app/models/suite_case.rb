class SuiteCase < ActiveRecord::Base
  belongs_to :test_suite
  validates :test_suite, :name, :grade, presence: true
end
