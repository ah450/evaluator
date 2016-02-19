# == Schema Information
#
# Table name: suite_codes
#
#  id            :integer          not null, primary key
#  test_suite_id :integer
#  code          :binary           not null
#  file_name     :string           not null
#  mime_type     :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_suite_codes_on_test_suite_id  (test_suite_id)
#
# Foreign Keys
#
#  fk_rails_77408f6d04  (test_suite_id => test_suites.id)
#

class SuiteCode < ActiveRecord::Base
  belongs_to :test_suite
  validates :file_name, presence: true
  validates :mime_type, presence: true
  validates :test_suite, presence: true
  include ZipFile
end
