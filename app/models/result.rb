class Result < ActiveRecord::Base
  belongs_to :submission
  belongs_to :test_suite
  has_many :test_cases, dependent: :delete_all
  has_many :team_grades
end
