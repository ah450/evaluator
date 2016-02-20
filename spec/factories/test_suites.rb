FactoryGirl.define do
  factory :test_suite do
    project { FactoryGirl.create(:project, published: true, course: FactoryGirl.create(:course, published: true)) }
    name 'csv_test_suite'
    factory :public_suite do
      hidden false
    end
    factory :private_suite do
      hidden true
    end
  end
end
