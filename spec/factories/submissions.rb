FactoryGirl.define do
  factory :submission do
    project do
      FactoryGirl.create(:project, published: true,
        course: FactoryGirl.create(:course, published: true))
    end
    submitter { FactoryGirl.create(:student, verified: true) }

    factory :submission_with_code do
      after(:create) do |submission|
        submission.solution = FactoryGirl.create(:solution, submission: submission)
      end
    end
  end
end
