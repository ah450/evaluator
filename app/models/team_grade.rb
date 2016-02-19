# == Schema Information
#
# Table name: team_grades
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  project_id :integer
#  hidden     :boolean          not null
#  result_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_team_grades_on_name_and_project_id  (name,project_id)
#  index_team_grades_on_project_id           (project_id)
#  index_team_grades_on_result_id            (result_id)
#
# Foreign Keys
#
#  fk_rails_2f72d5f42a  (project_id => projects.id)
#  fk_rails_bb58d44512  (result_id => results.id)
#

# Represents a grade for an entire team
# References the best submission result for that team.
class TeamGrade < ActiveRecord::Base
  belongs_to :project
  belongs_to :result
  validates :result, presence: true
  validates :project, presence: true
  validates :name, presence: true
  before_save :set_hidden

  def as_json(_options = {})
    super(include: [:result])
  end

  private

  def set_hidden
    self.hidden = result.hidden.to_s
  end
end
