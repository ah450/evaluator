FactoryGirl.define do
  factory :studentship do
    association :student
    association :course
  end
end
