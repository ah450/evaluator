class DestroyTestSuiteJob < ActiveJob::Base
  queue_as :default

  def perform(test_suite)
    # TODO: Change to destroy results only
    project = test_suite.project
    project.with_lock('FOR UPDATE') do
      # submissions with a result belonging to this suite
      Submission.where(project: project).joins(:results).where(results:
        {test_suite_id: test_suite.id}).each do |submission|
          submission.results.destroy_all
        end
      test_suite.destroy
    end
  end
end
