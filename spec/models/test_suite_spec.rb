require 'rails_helper'

RSpec.describe TestSuite, type: :model do
  it 'has a valid factory' do
    suite = FactoryGirl.build(:test_suite)
    expect(suite).to be_valid
  end
  it 'has a valid private factory' do
    suite = FactoryGirl.build(:private_suite)
    expect(suite).to be_valid
  end
  it 'has a valid public factory' do
    suite = FactoryGirl.build(:public_suite)
    expect(suite).to be_valid
  end
end
