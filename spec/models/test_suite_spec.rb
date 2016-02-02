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

  context 'destroyable' do

    it 'false for published project' do
      suite = FactoryGirl.create(:test_suite,
        project: FactoryGirl.create(:project, published: true)
      )
      expect(suite.destroyable?).to be false
    end
    it 'false for non ready suite' do
      suite = FactoryGirl.create(:test_suite, ready: false,
        project: FactoryGirl.create(:project, published: false)
      )
      expect(suite.destroyable?).to be false
    end
    it 'true for ready suite unpublished project' do
      suite = FactoryGirl.create(:test_suite, ready: true,
        project: FactoryGirl.create(:project, published: false)
      )
      expect(suite.destroyable?).to be true
    end
  end
end
