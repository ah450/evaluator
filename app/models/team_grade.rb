class TeamGrade < ActiveRecord::Base
  belongs_to :project
  belongs_to :result
end
