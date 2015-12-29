class Course < ActiveRecord::Base
  validates :name, :description, presence: true
  validates :name, uniqueness: { case_sensitive: false }
  has_many :studentships, inverse_of: :course
  has_many :students, through: :studentships, dependent: :delete_all, class_name: 'User'
  scope :published, -> { where published: true }
end
