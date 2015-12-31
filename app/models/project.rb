class Project < ActiveRecord::Base
  belongs_to :course, inverse_of: :projects
  has_many :submissions, inverse_of: :project
  validates :name, :due_date, :course, presence: true
  validate :unique_name_per_course
  before_save :due_date_to_utc, :default_start_date, :start_date_to_utc
  scope :published, -> { where published: true }
  scope :not_published, -> {where published: false }
  scope :due, ->  { where "due_date <= ?", DateTime.now.utc }
  scope :not_due, -> { where "due_date > ?", DateTime.now.utc }
  scope :started, -> { where "start_date <= ?", DateTime.now.utc }



  private

  def unique_name_per_course
    if !course.nil? && !name.nil? && !persisted?
      if Project.where(course: course, name: name).count != 0
        errors.add(:name, 'must be unique per course')
      end
    end
  end


  def due_date_to_utc
    self.due_date = due_date.utc
  end

  def default_start_date
    self.start_date = DateTime.now if start_date.nil?
  end

  def start_date_to_utc
    self.start_date = start_date.utc
  end

end
