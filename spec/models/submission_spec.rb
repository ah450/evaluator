require 'rails_helper'

RSpec.describe Submission, type: :model do
  it 'has a valid factory' do
    submission = FactoryGirl.build(:submission)
    expect(submission).to be_valid
  end
  context 'notifications' do
    it 'sends deleted notification' do
      submission = FactoryGirl.create(:submission)
      expect(Notifications::SubmissionsController).to receive(:publish).once
      submission.destroy
    end
  end
end
