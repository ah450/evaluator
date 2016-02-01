class TestSuite < ActiveRecord::Base
  belongs_to :project, inverse_of: :test_suites
  has_one :suite_code, dependent: :delete
  has_many :suite_cases, dependent: :delete_all
  has_many :results, dependent: :destroy
  validates :name, presence: true

  def as_json(options={})
    super(include: [:suite_cases])
  end

  def send_processed_notification
    event = {
      type: Rails.application.config.configurations[:notification_event_types][:test_suite_processed],
      date: DateTime.now.utc,
      payload: {
        test_suite: as_json
      }
    }
    Notifications::TestSuitesController.publish(
      "/notifications/test_suites/#{id}",
      event
    )
  end

  def self.viewable_by_user(user)
    self
  end

  def destroyable?
    !project.published?
  end

end
