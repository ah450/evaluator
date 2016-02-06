class Api::TeamsController < ApplicationController
  before_action :authenticate, :authorize
  before_action :authorize_teacher

  def create
    TeamJob.transaction do
      file = params.require(:file)
      @team_job = TeamJob.new
      @team_job.user = @current_user
      @team_job.data = file.read
      if @team_job.save
        render json: @team_job, status: :created
      else
        render json: @team_job.errors, status: :unprocessable_entity
      end
    end
    if @team_job.persisted?
      TeamAssignmentJob.perform_later @team_job
    end
  end
end
