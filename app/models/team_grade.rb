=begin
Represents a grade for an entire team
References the best submission result for that team.
=end
class TeamGrade < ActiveRecord::Base
  belongs_to :project
  belongs_to :result
  validates :result, presence: true
  validates :project, presence: true
  validates :name, presence: true
  before_save :set_hidden


  private
  def set_hidden
    self.hidden = "#{result.hidden}"
  end
end
