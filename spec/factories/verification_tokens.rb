FactoryGirl.define do
  factory :verification_token do
    user {FactoryGirl.create(:user)}
    token { SecureRandom.urlsafe_base64 User.verification_token_str_max_length }

  end

end
