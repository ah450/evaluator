class TestSuite < ActiveRecord::Base
  belongs_to :project, inverse_of: :test_suites
  has_one :suite_code, dependent: :delete
  has_many :suite_cases, dependent: :delete_all
  has_many :results, dependent: :destroy
  validates :name, presence: true

  def as_json(options={})
    super(include: [:suite_cases])
  end


  def self.viewable_by_user(user)
    if user.student?
      where(hidden: false)
    else
      self
    end
  end

  def destroyable?
    !project.published?
  end

end
