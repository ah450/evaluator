class SuiteCode < ActiveRecord::Base
  belongs_to :test_suite
  validates :file_name, presence: true
  validates :mime_type, presence: true
  validates :test_suite, presence: true
  include ZipFile
end
