FactoryGirl.define do
  factory :contact do
    text { Faker::Hipster.paragraph }
    title { Faker::Book.title }
    reported_at { DateTime.now.utc }
  end
end
