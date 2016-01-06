require 'rails_helper'

RSpec.describe ResetToken, type: :model do
  it 'has a valid factory' do
    token = FactoryGirl.build(:reset_token)
    expect(token).to be_valid
  end
  it 'requires token' do
    token = FactoryGirl.build(:reset_token, token: nil)
    expect(token).to_not be_valid
  end
  it 'requires user' do
    token = FactoryGirl.build(:reset_token, user: nil)
    expect(token).to_not be_valid
  end
end
