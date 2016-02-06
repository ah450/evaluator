class TeamJob < ActiveRecord::Base
  belongs_to :user

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
end
