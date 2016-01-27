class Studentship < ActiveRecord::Base
  belongs_to :course, inverse_of: :studentships
  belongs_to :student, class_name: "User", inverse_of: :studentships
end
