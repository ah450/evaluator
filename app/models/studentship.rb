# == Schema Information
#
# Table name: studentships
#
#  id         :integer          not null, primary key
#  course_id  :integer
#  student_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_studentships_on_course_id   (course_id)
#  index_studentships_on_student_id  (student_id)
#
# Foreign Keys
#
#  fk_rails_783f5c526c  (course_id => courses.id)
#  fk_rails_be0c5c84e7  (student_id => users.id)
#

class Studentship < ActiveRecord::Base
  belongs_to :course, inverse_of: :studentships
  belongs_to :student, class_name: 'User', inverse_of: :studentships
  validates :student, :course, presence: true
end
