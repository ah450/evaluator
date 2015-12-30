class Project < ActiveRecord::Base
  belongs_to :course
  validates :name, :due_date, :course, presence: true
  validate :unique_name_per_course
  before_save :due_date_to_utc
  scope :published, -> { where published: true }
  scope :not_published, -> {where published: false }
  scope :ready, -> { where ready: true }
  scope :due, ->  { where "due_date <= ?", DateTime.now.utc }
  scope :not_due, -> { where "due_date > ?", DateTime.now.utc }



  private

  def unique_name_per_course
    if !course.nil? && !name.nil?
      if Project.where(course: course, name: name).count != 0
        errors.add(:name, 'must be unique per course')
      end
    end
  end


  def due_date_to_utc
    self.due_date = due_date.utc
  end

end
