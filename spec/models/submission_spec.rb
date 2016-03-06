require 'rails_helper'

RSpec.describe Submission, type: :model do
  it { should belong_to :project }
  it { should belong_to :submitter }
  it { should have_one :solution }
  it { should have_many :results }
  it { should validate_presence_of :project }
  it { should validate_presence_of :submitter }

  it 'does not submit to a due project' do
    project = FactoryGirl.create(:project, published: true,
    due_date: DateTime.now.utc,
    course: FactoryGirl.create(:course, published: true)
    )
    submission = FactoryGirl.build(:submission, project: project)
    expect(submission).to_not be_valid
    expect(submission.errors[:project]).to contain_exactly('Must be before deadline')
  end

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

  context 'newest_per_submitter_of_project' do
    it 'There are four results' do
      project = FactoryGirl.create(:project, published: true, course: FactoryGirl.create(:course, published: true))
      submitter_one = FactoryGirl.create(:student, verified: true)
      submitter_two = FactoryGirl.create(:student, verified: true)
      submitter_three = FactoryGirl.create(:student, verified: true)
      submitter_four = FactoryGirl.create(:student, verified: true)

      submissions_one = FactoryGirl.create_list(:submission_with_code, 30, project: project, submitter: submitter_one)
      submissions_two = FactoryGirl.create_list(:submission_with_code, 30, project: project, submitter: submitter_two)
      submissions_thre = FactoryGirl.create_list(:submission_with_code, 30, project: project, submitter: submitter_three)
      submissions_four = FactoryGirl.create_list(:submission_with_code, 30, project: project, submitter: submitter_four)

      expect(Submission.newest_per_submitter_of_project(project).count).to eql 4
    end
  end
end
