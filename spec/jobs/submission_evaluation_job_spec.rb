require 'rails_helper'

RSpec.describe SubmissionEvaluationJob, type: :job do
  context 'csv' do
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
    end

    context 'csv_submission_correct' do
      before :each do
        @submission = Submission.new
        @submission.submitter = FactoryGirl.create(:student, verified: true)
        @submission.project = @project
        @submission.save!
        solution = Solution.new
        solution.file_name = 'csv_submission_correct.zip'
        solution.mime_type = Rack::Mime.mime_type '.zip'
        solution.submission = @submission
        solution.code = IO.binread(File.join(Rails.root, 'spec', 'fixtures',
          'files', 'submissions', 'csv_submission_correct.zip'))
        solution.save!
      end

      it 'sends new result notification' do
        expect(@submission).to receive(:send_new_result_notification).once
        SubmissionEvaluationJob.perform_now @submission
      end



      it 'creates a result and TeamGrade' do
        expect {
          SubmissionEvaluationJob.perform_now @submission
          }.to change(Result, :count).by(1).and change(TeamGrade, :count).by(1)
      end

      it 'sets correct grade' do
        SubmissionEvaluationJob.perform_now @submission
        result = @submission.results.first
        expect(result.grade).to eql @suite.max_grade
      end

      it 'sets correct team grade' do
        SubmissionEvaluationJob.perform_now @submission
        result = @submission.results.first
        expect(result.team_grade.nil?).to be false
      end


      it 'sets correct result attributes and cases' do
        SubmissionEvaluationJob.perform_now @submission
        result = @submission.results.first
        expect(result.compiled).to be true
        expect(result.success).to be true
        result_case = result.test_cases.first
        expect(result_case.grade).to eql 40
        expect(result_case.java_klass_name).to eql 'TestFileReadTest'
        expect(result_case.name).to eql 'countLines'
        expect(result_case.max_grade).to eql 40
        expect(result_case.passed).to be true
      end
    end

    context 'csv_submission' do
      before :each do
        @submission = Submission.new
        @submission.submitter = FactoryGirl.create(:student, verified: true)
        @submission.project = @project
        @submission.save!
        solution = Solution.new
        solution.file_name = 'csv_submission.zip'
        solution.mime_type = Rack::Mime.mime_type '.zip'
        solution.submission = @submission
        solution.code = IO.binread(File.join(Rails.root, 'spec', 'fixtures',
          'files', 'submissions', 'csv_submission.zip'))
        solution.save!
      end
      it 'sends new result notification' do
        expect(@submission).to receive(:send_new_result_notification).once
        SubmissionEvaluationJob.perform_now @submission
      end



      it 'creates a result and TeamGrade' do
        expect {
          SubmissionEvaluationJob.perform_now @submission
          }.to change(Result, :count).by(1).and change(TeamGrade, :count).by(1)
      end

      it 'sets correct grade' do
        SubmissionEvaluationJob.perform_now @submission
        result = @submission.results.first
        expect(result.grade).to eql 0
      end

      it 'sets correct team grade' do
        SubmissionEvaluationJob.perform_now @submission
        result = @submission.results.first
        expect(result.team_grade.nil?).to be false
      end


      it 'sets correct result attributes and cases' do
        SubmissionEvaluationJob.perform_now @submission
        result = @submission.results.first
        expect(result.compiled).to be true
        expect(result.success).to be false
        result_case = result.test_cases.first
        expect(result_case.grade).to eql 0
        expect(result_case.java_klass_name).to eql 'TestFileReadTest'
        expect(result_case.name).to eql 'countLines'
        expect(result_case.max_grade).to eql 40
        expect(result_case.passed).to be false
      end
    end
  end
end
