# == Schema Information
#
# Table name: solutions
#
#  id            :integer          not null, primary key
#  submission_id :integer
#  code          :binary           not null
#  file_name     :string           not null
#  mime_type     :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_solutions_on_submission_id  (submission_id)
#
# Foreign Keys
#
#  fk_rails_60e25972da  (submission_id => submissions.id)
#

class Solution < ActiveRecord::Base
  belongs_to :submission
  validates :file_name, presence: true
  validates :mime_type, presence: true
  validates :submission, presence: true
  include ZipFile

  def generate_file_name
    name = "#{submission.submitter.guc_id}-#{submission.submitter.team}@#{submission.created_at}.zip"
    sanitize_filename(name)
  end
end
