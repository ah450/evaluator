# == Schema Information
#
# Table name: suite_cases
#
#  id            :integer          not null, primary key
#  test_suite_id :integer
#  name          :string           not null
#  grade         :integer          default(0), not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_suite_cases_on_name           (name)
#  index_suite_cases_on_test_suite_id  (test_suite_id)
#
# Foreign Keys
#
#  fk_rails_78e31a4fd8  (test_suite_id => test_suites.id)
#

class SuiteCase < ActiveRecord::Base
  belongs_to :test_suite
  validates :test_suite, :name, :grade, presence: true
end
