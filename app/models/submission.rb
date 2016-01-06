class Submission < ActiveRecord::Base
  belongs_to :project
  belongs_to :submitter, class_name: "User", inverse_of: :submissions
  belongs_to :solution, dependent: :delete
  validates :project, :submitter, presence: true
  has_many :results, dependent: :destroy
  validate :published_project_and_course

  def as_json(options={})
    super(except: [:solution_id])
  end

  private
  def published_project_and_course
    if !project.nil?
      if project.course.nil? || !project.published? || !project.course.published?
        errors.add(:project, 'Must be published and belong to a published course')
      end
    end
  end

  def self.viewable_by_user(user)
    if user.student?
      joins(:submitter).where(users: {team: user.team})
    else
      self
    end
  end
end
