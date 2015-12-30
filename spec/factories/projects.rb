FactoryGirl.define do
  factory :project do
    due_date {Faker::Time.forward(32, :morning)}
    name {Faker::App.name}
    course {FactoryGirl.create(:course)}
  end

end
