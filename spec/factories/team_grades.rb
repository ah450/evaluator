FactoryGirl.define do
  factory :team_grade do
    result
    project { result.project }
    name { result.submission.submitter.team }
    submission { result.submission }
  end
end
