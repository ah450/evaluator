FactoryGirl.define do
  factory :submission do
    project {FactoryGirl.create(:project, published: true, course: FactoryGirl.create(:course, published: true) )}
    submitter {FactoryGirl.create(:student, verified: true)}
  end

end
