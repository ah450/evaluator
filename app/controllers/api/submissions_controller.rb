class Api::SubmissionsController < ApplicationController
  prepend_before_action :set_parent, only: [:create, :index]
  # Authenticate on all actions
  prepend_before_action :authenticate, :authorize
  before_action :can_view, only: [:show, :download]
  around_action :wrap_in_transaction, only: [:create]

  def create
    @submission = Submission.new resource_params
    if @submission.save
      file = params.require(:file)
      solution_params = {
        code: file.read,
        file_name: file.original_filename,
        mime_type: file.content_type,
        submission: @submission
      }
      solution = Solution.new solution_params
      if solution.save
        render json: @submission, status: :created
      else
        render json: solution.errors, status: :unprocessable_entity
        raise ActiveRecord::Rollback
      end
    else
      render json: @submission.errors, status: :unprocessable_entity
      raise ActiveRecord::Rollback
    end
    if @submission.persisted?
      SubmissionEvaluationJob.perform_later @submission
      num_subs = Submission.where(submitter: @current_user,
                                 project: @project).count
      max_subs = Rails.application.config.configurations[:max_num_submissions]
      if num_subs > max_subs
        SubmissionCullingJob.perform_later(@current_user, @project)
      end
    end
  end

  # Returns code
  def download
    solution = @submission.solution
    options = {
      type: solution.mime_type,
      disposition: 'attachment',
      filename: solution.file_name
    }
    send_data solution.code, **options
  end

  private

  def query_params
    params.permit(:submitter_id, :project_id)
  end

  def params_helper
    attributes = model_attributes
    attributes.delete :id
    attributes.delete :project_id
    attributes.delete :solution_id
    attributes.delete :submitter_id
    permitted = params.permit attributes
    inferred = {
      submitter: @current_user
    }
    inferred[:project] = @project unless @project.nil?
    permitted.merge inferred
  end

  def submission_params
    @permitted_params ||= params_helper
  end

  def base_index_query
    query = Submission.viewable_by_user(@current_user).where(project: @project)
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
      query = query.joins(:submitter).where(users: user_query)
    end
    query
  end

  def set_parent
    @project ||= Project.find params[:project_id]
  end

  def can_view
    unless @current_user.can_view? @submission
      raise ForbiddenError, error_messages[:forbidden]
    end
  end

  def order_args
    { created_at: :desc }
  end

end
