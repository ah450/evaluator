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
  belongs_to :project
  belongs_to :submitter, class_name: 'User', inverse_of: :submissions
  has_one :solution, dependent: :delete
  validates :project, :submitter, presence: true
  has_many :results, dependent: :destroy
  validate :published_project_and_course
  after_destroy :send_deleted_notification

  def as_json(_options = {})
    super(except: [:solution_id])
      .merge({
        submitter: submitter.as_json
      })
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
      joins(:submitter).where(users: { team: user.team })
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
      ')'
    )
  end

  private

  def published_project_and_course
    unless project.nil?
      if project.course.nil? || !project.published? || !project.course.published?
        errors.add(:project, 'Must be published and belong to a published course')
      end
    end
  end
end
