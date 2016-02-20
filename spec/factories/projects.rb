FactoryGirl.define do
  factory :project do
    due_date { Faker::Time.forward(32, :morning) }
    name { (0...30).map { ('a'..'z').to_a[rand(26)] }.join }
    course { FactoryGirl.create(:course) }
  end
end
