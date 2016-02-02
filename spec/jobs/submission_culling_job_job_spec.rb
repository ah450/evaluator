require 'rails_helper'

RSpec.describe SubmissionCullingJobJob, type: :job do
  before :each do
    # setup project
    @project = FactoryGirl.create(:project, published: true,
      course: FactoryGirl.create(:course, published: true))
    # Setup test suite
    @suite = TestSuite.new
    @suite.project = @project
    @suite.name = 'csv_test_suite'
    @suite.save!
    code = SuiteCode.new
    code.code = IO.binread(File.join(Rails.root, 'spec', 'fixtures',
      '/files/test_suites/csv_test_suite.zip'))
    code.file_name = 'csv_test_suite.zip'
    code.mime_type = Rack::Mime.mime_type '.zip'
    code.test_suite = @suite
    code.save!
    # Run process job
    SuitesProcessJob.perform_now @suite
    @create_submission = lambda do |submitter|
      submission = Submission.new
      submission.submitter = submitter
      submission.project = @project
      submission.save!
      solution = Solution.new
      solution.file_name = 'csv_submission_correct.zip'
      solution.mime_type = Rack::Mime.mime_type '.zip'
      solution.submission = @submission
      solution.code = IO.binread(File.join(Rails.root, 'spec', 'fixtures',
        'files', 'submissions', 'csv_submission_correct.zip'))
      solution.save!
      SubmissionEvaluationJob.perform_now submission
      submission
    end
  end

  it 'keeps only the most recent 15'
    submitter = FactoryGirl.create(:student, verified: true)
    20.times { @create_submission.call(submitter) }
  end

end
