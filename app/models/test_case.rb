# == Schema Information
#
# Table name: test_cases
#
#  id              :integer          not null, primary key
#  result_id       :integer
#  name            :string           not null
#  detail          :text
#  java_klass_name :text
#  passed          :boolean          not null
#  grade           :integer          not null
#  max_grade       :integer          not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_test_cases_on_result_id  (result_id)
#
# Foreign Keys
#
#  fk_rails_417230dfee  (result_id => results.id)
#

# Model representing result of a suite_case when run against a submission.
class TestCase < ActiveRecord::Base
  belongs_to :result
end
