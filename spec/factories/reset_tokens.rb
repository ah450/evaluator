FactoryGirl.define do
  factory :reset_token do
    user {FactoryGirl.create(:student)}
    token {SecureRandom.urlsafe_base64}
  end
end
