class TeamJob < ActiveRecord::Base
  belongs_to :user
  validates :user, presence: true
  validate :data_exists


  def as_json(options={})
    super(only: [:id])
  end

  def send_status(status)
    event = {
      type: Rails.application.config.configurations[:notification_event_types][:team_job_status],
      date: DateTime.now.utc,
      payload: {
        status: status
      }
    }
    Notifications::TeamJobsController.publish(
      "/notifications/team_jobs/#{id}",
      event
    )
  end

  def data_exists
    if data.nil? || data.size == 0
      errors.add(:data, 'can not be blank')
    end
  end
end
