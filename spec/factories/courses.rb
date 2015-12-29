FactoryGirl.define do
  factory :course do
    name { Faker::Lorem.word }
    description { Faker::Lorem.paragraphs(3) }
  end

end
