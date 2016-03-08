module ResultIteratarable
  extend ActiveSupport::Concern

  private

  def team_grade_results(submission, suites)
    suites.each do |suite|
      next unless submission.submitter.student?
      submission_result = TeamGrade.find_by_sql(
        [
        'SELECT * FROM team_grades ' \
        'INNER JOIN results ON ' \
        'results.id = team_grades.result_id ' \
        'WHERE team_grades.name = ? ' \
        'AND results.test_suite_id = ? ' \
        'ORDER BY team_grades.created_at DESC ' \
        'LIMIT 1',
        submission.submitter.team, suite.id
        ]
      ).first
      yield submission_result.result if submission_result.present?
      yield nil if submission_result.nil?
    end
  end

  def all_results(submission, suites)
    suites.each do |suite|
      submission_result = submission.results.where(test_suite_id: suite.id).take
      yield submission_result
    end
  end
end
