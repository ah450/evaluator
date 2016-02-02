class Course < ActiveRecord::Base
  validates :name, :description, presence: true
  validates :name, uniqueness: { case_sensitive: false }
  has_many :studentships, inverse_of: :course
  has_many :students, through: :studentships, dependent: :delete_all, class_name: 'User'
  has_many :projects, inverse_of: :course, dependent: :destroy
  scope :published, -> { where published: true }
  after_create :send_created_notification
  after_save :send_published_notification
  after_destroy :send_delted_notification

  def register(student)
    students << student
  end

  def unregister(student)
    students.delete student
  end

  private

  def send_delted_notification
    event = {
      type: Rails.application.config.configurations[:notification_event_types][:course_deleted],
      date: DateTime.now.utc,
      payload: {
        course: as_json
      }
    }
    Notifications::CoursesController.publish(
      "/notifications/courses/#{id}",
      event
    )
  end
  
  def send_created_notification
    event = {
      type: Rails.application.config.configurations[:notification_event_types][:course_created],
      date: DateTime.now.utc,
      payload: {
        course: as_json
      }
    }
    Notifications::CoursesController.publish(
      "/notifications/courses/new",
      event
    )
  end

  def send_published_notification
    if published_changed?
      types = Rails.application.config.configurations[:notification_event_types]
      if published?
        type = types[:course_published]
      else
        type = types[:course_unpublished]
      end
      event = {
        type: type,
        date: DateTime.now.utc,
        payload: {
          course: as_json
        }
      }
      Notifications::CoursesController.publish(
        "/notifications/courses/new",
        event
      )
      Notifications::CoursesController.publish(
        "/notifications/courses/#{id}",
        event
      )
    end
  end

end
