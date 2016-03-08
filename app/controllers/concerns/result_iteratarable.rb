module ResultIteratarable
  extend ActiveSupport::Concern

  private

  def team_grade_results(submission, suites)
    suites.each do
      submission_result = TeamGrade.joins(:results).where(
        result: {
          submission_id: submission.id,
          test_suite_id: suite.id
        }).order(created_at: :desc).take
        yield submission_result
    end
  end

  def all_results(submission, suites)
    suites.each do |suite|
      submission_result = submission.results.where(test_suite_id: suite.id).take
      yield submission_result
    end
  end
end
