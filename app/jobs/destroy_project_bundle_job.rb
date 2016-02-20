class DestroyProjectBundleJob < ActiveJob::Base
  queue_as :default

  def perform(project_bundle)
    project_bundle.destroy
  end
end
