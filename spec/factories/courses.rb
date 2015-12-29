FactoryGirl.define do
  factory :course do
    name { Faker::Lorem.sentence(10) }
    description { Faker::Lorem.paragraph(3) }
  end

end
