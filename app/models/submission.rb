class Submission < ActiveRecord::Base
  belongs_to :project
  belongs_to :student, class_name: "User", inverse_of: :submissions
  belongs_to :solution, dependent: :delete
  has_many :results, dependent: :destroy
end
