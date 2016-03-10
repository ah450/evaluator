# == Schema Information
#
# Table name: team_grades
#
#  id            :integer          not null, primary key
#  name          :string           not null
#  project_id    :integer
#  hidden        :boolean          not null
#  result_id     :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  submission_id :integer          not null
#
# Indexes
#
#  index_team_grades_on_name_and_project_id           (name,project_id)
#  index_team_grades_on_project_id                    (project_id)
#  index_team_grades_on_result_id                     (result_id)
#  index_team_grades_on_submission_id_and_project_id  (submission_id,project_id)
#
# Foreign Keys
#
#  fk_rails_2cf3d7a059  (submission_id => submissions.id)
#  fk_rails_2f72d5f42a  (project_id => projects.id)
#  fk_rails_bb58d44512  (result_id => results.id)
#

# Represents a grade for an entire team
# References the best submission result for that team.
class TeamGrade < ActiveRecord::Base
  include Cacheable
  belongs_to :user, primary_key: 'team', foreign_key: 'name'
  belongs_to :project
  belongs_to :result
  belongs_to :submission
  validates :result, presence: true
  validates :project, presence: true
  validates :name, presence: true
  validates :submission, presence: true
  before_save :set_hidden

  def team_members
    User.where(team: name)
  end

  def as_json(_options = {})
    super.merge({
                  result: result.as_json,
                  team_members: team_members.map(&:as_json),
                  submission: submission.as_json
                })
  end



  private

  def set_hidden
    self.hidden = result.hidden.to_s
  end
end
