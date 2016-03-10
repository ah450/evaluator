class Api::ProjectBundlesController < ApplicationController
  before_action :authenticate, :authorize
  before_action :authorize_teacher

  def create
    @project_bundle = ProjectBundle.new resource_params
    if @project_bundle.save
      if params[:teams_only]
        ProjectTeamsBundleJob.perform_later(@project_bundle)
      else
        ProjectBundleJob.perform_later(@project_bundle)
      end
      render json: @project_bundle, status: :created
    else
      render json: @project_bundle.errors, status: :unprocessable_entity
    end
  end

  def download
    options = {
      type: Rack::Mime.mime_type('.tar.gz'),
      disposition: 'attachment',
      filename: @project_bundle.filename
    }
    send_data @project_bundle.data, **options
  end

  private

  def params_helper
    {
      user: @current_user,
      project: Project.find(params.require(:project_id))
    }
  end

  def project_bundle_params
    @permitted_params ||= params_helper
  end
end
