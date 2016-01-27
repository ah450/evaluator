require 'rails_helper'

RSpec.describe Solution, type: :model do
  it 'has a valid factory' do
    submission = FactoryGirl.create(:submission)
    solution = FactoryGirl.build(:solution, submission: submission)
    expect(solution).to be_valid
  end
end
