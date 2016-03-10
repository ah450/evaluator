# == Schema Information
#
# Table name: submissions
#
#  id           :integer          not null, primary key
#  project_id   :integer
#  submitter_id :integer          not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_submissions_on_created_at    (created_at)
#  index_submissions_on_project_id    (project_id)
#  index_submissions_on_submitter_id  (submitter_id)
#
# Foreign Keys
#
#  fk_rails_9099815ed5  (project_id => projects.id)
#  fk_rails_b52d5c1bed  (submitter_id => users.id)
#

class Submission < ActiveRecord::Base
  include Cacheable
  belongs_to :project
  belongs_to :submitter, class_name: 'User', inverse_of: :submissions
  has_one :solution, dependent: :delete
  validates :project, :submitter, presence: true
  has_many :results, dependent: :destroy
  has_many :team_grades, dependent: :delete_all
  validate :published_project_and_course
  validate :project_can_submit
  after_destroy :send_deleted_notification

  def as_json(_options = {})
    super(except: [:solution_id])
      .merge(submitter: submitter.as_json)
  end

  def send_new_result_notification(result)
    event = {
      type: Rails.application.config.configurations[:notification_event_types][:submission_result_ready],
      date: DateTime.now.utc,
      payload: {
        result: result.as_json
      }
    }
    Notifications::SubmissionsController.publish(
      "/notifications/submissions/#{id}",
      event
    )
  end

  def send_deleted_notification
    event = {
      type: Rails.application.config.configurations[:notification_event_types][:submission_deleted],
      date: DateTime.now.utc
    }
    Notifications::SubmissionsController.publish(
      "/notifications/submissions/#{id}",
      event
    )
  end

  def self.viewable_by_user(user)
    if user.student?
      user.submissions
    else
      self
    end
  end

  def self.newest_per_submitter_of_project(project)
    project.submissions.where(
      'NOT EXISTS ( ' \
      'SELECT 1 FROM submissions AS other ' \
      'WHERE other.submitter_id = submissions.submitter_id ' \
      'AND other.created_at > submissions.created_at ' \
      "AND other.project_id = #{project.id}" \
      ')'
    )
  end

  def self.newest_per_team_of_project(project)
    find_by_sql(
      [
        'SELECT submissions.* FROM submissions ' \
        ' INNER JOIN users ON submissions.submitter_id = users.id ' \
        ' INNER JOIN team_grades ON users.team = team_grades.name ' \
        ' WHERE users.team IS NOT NULL AND submissions.project_id = ? ' \
        'AND NOT EXISTS ( SELECT * FROM team_grades AS other ' \
        ' WHERE other.name = team_grades.name AND other.project_id = ? ' \
        ' AND other.created_at > team_grades.created_at ' \
        ' AND other.submission_id = submissions.id ) ',
        project.id, project.id
      ]
    )
  end

  private

  def project_can_submit
    errors.add(:project, 'Must be before deadline and after start date') unless
      project.nil? || project.can_submit?
  end

  def published_project_and_course
    unless project.nil?
      if project.course.nil? || !project.published? || !project.course.published?
        errors.add(:project, 'Must be published and belong to a published course')
      end
    end
  end
end
