FactoryGirl.define do
  factory :suite_case do
    test_suite {FactoryGirl.create(:test_suite)}
    name "testName"
    grade 1
  end

end
