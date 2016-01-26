class Solution < ActiveRecord::Base
  belongs_to :submission
  validates :file_name, presence: true
  validates :mime_type, presence: true
  validates :submission, presence: true
  include ZipFile
end
