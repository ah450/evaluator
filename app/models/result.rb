=begin
Represents results for an individual submission.
This is different than team results
=end
class Result < ActiveRecord::Base
  belongs_to :submission
  belongs_to :test_suite
  belongs_to :project
  validates :submission, :test_suite, :project, presence: true
  validates :compiler_stderr, :compiler_stdout, :grade, :max_grade, presence: true
  has_many :test_cases, dependent: :delete_all
  has_one :team_grade
  validate :grade_range
  validate :boolean_validations
  before_save :set_hidden



  # Can not view hidden results
  # Can view results that belong to a team's own submission
  def self.viewable_by_user(user)
    if user.student?
      where(hidden: false).joins(submission: :submitter).where(users: {team: user.team})
    else
      self
    end
  end

  def as_json(options={})
    super(include: [:test_suite, :test_cases])
  end

  private

  def grade_range
    if !max_grade.nil? && !grade.nil? && !grade.between?(0, max_grade)
      errors.add(:grade, "must be between 0 and #{max_grade}")
    end
  end

  def set_hidden
    self.hidden = "#{test_suite.hidden}"
  end

  def boolean_validations
    if compiled.nil?
      errors.add(:compiled, "can not be blank")
    end
    if success.nil?
      errors.add(:success, "can not be blank")
    end
  end
end
