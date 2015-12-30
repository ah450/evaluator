class Course < ActiveRecord::Base
  validates :name, :description, presence: true
  validates :name, uniqueness: { case_sensitive: false }
  has_many :studentships, inverse_of: :course
  has_many :students, through: :studentships, dependent: :delete_all, class_name: 'User'
  has_many :projects, inverse_of: :course, dependent: :destroy
  scope :published, -> { where published: true }

  def register(student)
    students << student
  end

  def unregister(student)
    students.delete student
  end

end
