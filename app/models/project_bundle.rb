# == Schema Information
#
# Table name: project_bundles
#
#  id         :integer          not null, primary key
#  project_id :integer
#  user_id    :integer
#  data       :binary
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_project_bundles_on_project_id  (project_id)
#  index_project_bundles_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_520318e552  (user_id => users.id)
#  fk_rails_5688cfe5e6  (project_id => projects.id)
#

class ProjectBundle < ActiveRecord::Base
  belongs_to :user
  belongs_to :project
  validates :user, :project, presence: :true
  validate :user_teacher

  def as_json(_options = {})
    super(except: [:data],
          methods: [:ready, :project_name]
      )
  end

  def ready
    data.present? && data.size != 0
  end

  def project_name
    project.name
  end

  def filename
    "#{DateTime.now.utc}-#{project.name}-#{user.name}.tar.gz"
  end

  private

  def user_teacher
    errors.add(:user, 'must be teacher') if !user.nil? && user.student
  end
end
