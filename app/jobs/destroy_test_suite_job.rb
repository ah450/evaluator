class DestroyTestSuiteJob < ActiveJob::Base
  queue_as :default

  def perform(test_suite)
    project = test_suite.project
    project.with_lock('FOR UPDATE') do
      test_suite.destroy
    end
  end
end
