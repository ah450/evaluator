require 'rails_helper'

RSpec.describe Submission, type: :model do
  it 'has a valid factory' do
    submission = FactoryGirl.build(:submission)
    expect(submission).to be_valid
  end
end
