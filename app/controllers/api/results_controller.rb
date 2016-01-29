class Api::ResultsController < ApplicationController
  prepend_before_action :authorize
  prepend_before_action :set_parent, only: [:index]
  prepend_before_action :authenticate
  before_action :can_view, only: [:show]

  private

  
  def set_parent
    @project ||= Project.find params[:project_id]
  end
  
  def query_params
    params.permit(:submission_id)
  end

  def base_index_query
    query = Result.viewable_by_user(@current_user).where(project: @project)
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
        query = query.joins(submission: :submitter).where(users: userQuery)
    end
    return query
  end

  def can_view
    if !@current_user.can_view? @result
      raise ForbiddenError, error_messages[:forbidden]
    end
  end

end
