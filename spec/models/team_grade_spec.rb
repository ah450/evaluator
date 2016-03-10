require 'rails_helper'

RSpec.describe TeamGrade, type: :model do
  it { should belong_to :project }
  it { should belong_to :result }
  it { should belong_to :user }
  it { should belong_to :submission }
  it { should validate_presence_of :result }
  it { should validate_presence_of :project }
  it { should validate_presence_of :name }
  it { should validate_presence_of :submission }

  let(:subject){ FactoryGirl.build(:team_grade) }
  it 'Should have a valid factory' do
    expect(subject).to be_valid
  end

end
