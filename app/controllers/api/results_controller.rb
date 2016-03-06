require 'csv'
class Api::ResultsController < ApplicationController
  before_action :set_resource, except: [:index, :create, :csv]
  prepend_before_action :authorize
  prepend_before_action :set_parent, only: [:index, :csv]
  prepend_before_action :authenticate
  before_action :can_view, only: [:show]
  before_action :authorize_teacher, only: [:csv]

  def csv
    file = Tempfile.new 'results'
    CSV.open(file, 'w') do |csv|
      headers = %w(ID TEAM EMAIL MAJOR SUBMISSION_DATE)
      suites = @project.test_suites.order(:created_at)
      suites.each do |suite|
        headers << "#{suite.name.upcase}_GRADE"
        headers << "#{suite.name.upcase}_COMPILED"
      end
      headers << %w(TOTAL_GRADE ALL_COMPILED)
      csv << headers
      @project.submissions.each do |submission|
        next unless submission.submitter.student?
        data = [submission.submitter.guc_id,
                submission.submitter.team,
                submission.submitter.email,
                submission.submitter.major,
                submission.created_at
        ]
        # Total Grade
        suites.each do |suite|
          submission_suite = submission.results.where(test_suite_id: suite.id).take
          if submission_suite.nil?
            data << 'NO_RESULT' << 'NO_RESULT'
          else
            data << suite.grade << suite.compiled
          end
        end
        data << submission.results.reduce(0) { |a, e| a + e.grade }
        # All Compiled
        data << submission.results.reduce(true) { |a, e| a && e.compiled }
        csv << data
      end
    end
    options = {
      type: Rack::Mime.mime_type('.csv'),
      disposition: 'attachment',
      filename: "#{DateTime.now.utc}-#{@project.name}-results.csv"
    }
    file.rewind
    send_data file.read, **options
    file.close
    file.unlink
  end

  private

  def set_parent
    @project ||= Project.find params[:project_id]
  end

  def query_params
    params.permit(:submission_id)
  end

  def base_index_query
    query = Result.viewable_by_user(@current_user)
                  .where(project: @project)
    possible_user_fields = User.queriable_fields
    # A query based on user fields
    if params.key?(:submitter) &&
       possible_user_fields.any? { |e| params[:submitter].key? e }
      user_query = {}
      for user_field in possible_user_fields do
        if params[:submitter].key? user_field
          user_query[user_field] = params[:submitter][user_field]
        end
      end
      query = query.joins(submission: :submitter)
                   .where(users: user_query)
    end
    query
  end

  def can_view
    unless @current_user.can_view? @result
      raise ForbiddenError, error_messages[:forbidden]
    end
  end
end
