require 'rails_helper'

RSpec.describe SuiteCase, type: :model do
  it { should belong_to :test_suite }
  it { should validate_presence_of :test_suite }
  it { should validate_presence_of :name }
  it { should validate_presence_of :grade }
  it 'has a valid factory' do
    suit_case = FactoryGirl.build(:suite_case)
    expect(suit_case).to be_valid
  end

  it 'requires a name' do
    suit_case = FactoryGirl.build(:suite_case, name: nil)
    expect(suit_case).to_not be_valid
  end

  it 'requires a grade' do
    suit_case = FactoryGirl.build(:suite_case, grade: nil)
    expect(suit_case).to_not be_valid
  end

  it 'requires a test suite association' do
    suit_case = FactoryGirl.build(:suite_case, test_suite: nil)
    expect(suit_case).to_not be_valid
  end
end
