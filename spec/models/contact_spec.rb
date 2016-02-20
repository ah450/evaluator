require 'rails_helper'

RSpec.describe Contact, type: :model do
  it { should belong_to :user }
  it { should validate_presence_of :text }
  it { should validate_presence_of :title }
  it { should validate_presence_of :reported_at }

  it 'should have a valid factory' do
    expect(FactoryGirl.build(:contact)).to be_valid
  end
end
