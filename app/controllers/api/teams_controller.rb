require 'csv'
class Api::TeamsController < ApplicationController
  before_action :authenticate, :authorize
  before_action :authorize_super_user, only: [:create]
  before_action :authorize_teacher

  def index
    file = Tempfile.new 'teams'
    CSV.open(file, 'w') do |csv|
      csv << %w(ID TEAM EMAIL MAJOR CREATED_AT)
      User.students.each do |student|
        csv << [student.guc_id, student.team, student.email, student.major,
              student.created_at]
      end
    end

    options = {
      type: Rack::Mime.mime_type('.csv'),
      disposition: 'attachment',
      filename: "#{DateTime.now.utc}-students.csv"
    }
    file.rewind
    send_data file.read, **options
    file.close
    file.unlink
  end

  def create
    file = params.require(:file)
    @team_job = TeamJob.new
    @team_job.user = @current_user
    @team_job.data = file.read
    if @team_job.save
      render json: @team_job, status: :created
    else
      render json: @team_job.errors, status: :unprocessable_entity
    end
    TeamAssignmentJob.perform_later @team_job if @team_job.persisted?
  end
end
