class TestSuite < ActiveRecord::Base
  belongs_to :project, inverse_of: :test_suites
  belongs_to :suite_code, dependent: :delete
  has_many :suite_cases, dependent: :delete_all
  has_many :results, dependent: :destroy
  validates :name, presence: true
end
