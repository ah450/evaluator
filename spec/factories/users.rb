FactoryGirl.define do
  factory :user do
    name {Faker::Name.name}
    password {Faker::Internet.password}
    verified true

    factory :student do
      email { (0...10).map { ('a'..'z').to_a[rand(26)] }.join + "@student.guc.edu.eg" }
      major {Faker::Lorem.word}
      team {Faker::Team.name}
      guc_suffix {Faker::Number.number(4)}
      guc_prefix {Faker::Number.number(2)}
    end

    factory :teacher do
      email { (0...10).map { ('a'..'z').to_a[rand(26)] }.join + "@guc.edu.eg" }
    end

  end

end
