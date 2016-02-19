require 'rails_helper'

RSpec.describe Solution, type: :model do
  it { should belong_to :submission }
  it { should validate_presence_of :file_name }
  it { should validate_presence_of :mime_type }
  it { should validate_presence_of :submission }

  it 'has a valid factory' do
    submission = FactoryGirl.create(:submission)
    solution = FactoryGirl.build(:solution, submission: submission)
    expect(solution).to be_valid
  end
end
