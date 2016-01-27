FactoryGirl.define do
  factory :verification_token do
    user {FactoryGirl.create(:student)}
    token { SecureRandom.urlsafe_base64 }
  end

end
