class Api::SubmissionsController < ApplicationController
  prepend_before_action :set_parent, only: [:create, :index]
  # Authenticate on all actions
  prepend_before_action :authenticate, :authorize
  before_action :can_view, only: [:show, :download]

  def create
    Submission.transaction do
      @submission = Submission.new resource_params
      if @submission.save
        file = params.require(:file)
        solution_params = {
          code: IO.binread(file),
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
    params.permit(:student_id, :project_id)
  end

  def params_helper
    attributes = model_attributes
    attributes.delete :id
    attributes.delete :project_id
    attributes.delete :solution_id
    attributes.delete :student_id
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
    if (params.has_key?(:submitter) &&
      possible_user_fields.any? {|e| params[:submitter].has_key? e})
      userQuery = {}
      for user_field in possible_user_fields do
        if params[:submitter].has_key? user_field
          userQuery[user_field] = params[:submitter][user_field]
        end
      end
        query = query.joins(:submitter).where(users: userQuery)
    end
    return query
  end

  def set_parent
    @project ||= Project.find params[:project_id]
  end

  def can_view
    if !@current_user.can_view? @submission
      raise ForbiddenError, error_messages[:forbidden]
    end
  end

end
