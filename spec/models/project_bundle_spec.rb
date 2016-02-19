require 'rails_helper'

RSpec.describe ProjectBundle, type: :model do
  it { should validate_presence_of :user }
  it { should validate_presence_of :project }
  it { should belong_to :user }
  it { should belong_to :project }

  it 'user must be teacher' do
    bundle = FactoryGirl.build(:project_bundle, user: FactoryGirl.create(:student))
    expect(bundle).to_not be_valid
  end

  it 'has a valid factory' do
    bundle = FactoryGirl.build(:project_bundle)
    expect(bundle).to be_valid
  end
end
