class TestSuite < ActiveRecord::Base
  belongs_to :project, inverse_of: :test_suites
  belongs_to :code, class_name: "SuiteCode", dependent: :delete
  has_many :suite_cases, dependent: :delete_all
  has_many :results, dependent: :destroy
end
