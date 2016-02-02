class DestroyTestSuiteJob < ActiveJob::Base
  queue_as :default

  def perform(test_suite)
    project = test_suite.project
    project.with_lock('FOR UPDATE') do
      # submissions with a result belonging to this suite
      Submission.where(project: project).joins(:results).where(results:
        {test_suite_id: test_suite.id}).destroy_all
      test_suite.destroy
    end
  end
end
