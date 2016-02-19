class Solution < ActiveRecord::Base
  belongs_to :submission
  validates :file_name, presence: true
  validates :mime_type, presence: true
  validates :submission, presence: true
  include ZipFile

  def generate_file_name
    name = "#{submission.submitter.guc_id}@#{submission.created_at}.zip"
    sanitize_filename(name)
  end
end
