module ResultIteratarable
  extend ActiveSupport::Concern

  private

  def team_grade_results(submission, suites, data)
    total_grade = 0
    all_compiled = true
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
      if submission_result.nil?
        yield nil
        all_compiled = false
      else
        yield submission_result.result if submission_result.present?
        total_grade += submission.result.grade
        all_compiled &= submission.result.compiled
      end
    end
    # Total Grade & All Compiled
    data << total_grade << all_compiled
  end

  def all_results(submission, suites, data)
    suites.each do |suite|
      submission_result = submission.results.where(test_suite_id: suite.id).take
      yield submission_result
      # Total Grade
      data << submission.results.reduce(0) { |a, e| a + e.grade }
      # All Compiled
      data << submission.results.reduce(true) { |a, e| a && e.compiled }
    end
  end
end
