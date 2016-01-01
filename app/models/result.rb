class Result < ActiveRecord::Base
  belongs_to :submission
  belongs_to :test_suite
  belongs_to :project
  has_many :test_cases, dependent: :delete_all
  has_one :team_grades
end
