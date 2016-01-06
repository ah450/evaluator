class Solution < ActiveRecord::Base
  belongs_to :submission
  validates :file_name, presence: true
  validates :mime_type, presence: true
  validates :submission, presence: true
  validate :code_exists


  private

  def code_exists
    code.size > 0
  end
end
