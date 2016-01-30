class Submission < ActiveRecord::Base
  belongs_to :project
  belongs_to :submitter, class_name: "User", inverse_of: :submissions
  has_one :solution, dependent: :delete
  validates :project, :submitter, presence: true
  has_many :results, dependent: :destroy
  validate :published_project_and_course

  def as_json(options={})
    super(except: [:solution_id])
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

  private
  def published_project_and_course
    if !project.nil?
      if project.course.nil? || !project.published? || !project.course.published?
        errors.add(:project, 'Must be published and belong to a published course')
      end
    end
  end

  def self.viewable_by_user(user)
    if user.student?
      joins(:submitter).where(users: {team: user.team})
    else
      self
    end
  end
end
