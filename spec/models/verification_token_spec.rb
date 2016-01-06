require 'rails_helper'

RSpec.describe VerificationToken, type: :model do
  it 'has a valid factory' do
    token = FactoryGirl.build(:verification_token)
    expect(token).to be_valid
  end
  it 'requires token' do
    token = FactoryGirl.build(:verification_token, token: nil)
    expect(token).to_not be_valid
  end
  it 'requires user' do
    token = FactoryGirl.build(:verification_token, user: nil)
    expect(token).to_not be_valid
  end
end
