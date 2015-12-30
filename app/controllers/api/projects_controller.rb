class Api::ProjectsController < ApplicationController
  prepend_before_action :set_parent, only: [:create, :index]
  prepend_before_action :authorize_teacher, only: [:destroy, :update, :create]
  prepend_before_action :authenticate
  before_action :hide_unpublished, only: [:index]
  before_action :hide_unpublished_single, only: [:show]

  private

  # Prevent students from viewing unpublsihed projects
  # Or any projects belonging to an unpublished course
  def hide_unpublished_single
    if @current_user.student? && ( !get_resource.published? ||
      !get_resource.course.published?)
      raise ForbiddenError, error_messages[:forbidden_teacher_only]
    end
  end

  
  def project_params
    attributes = model_attributes << :course
    attributes.delete :id
    attributes.delete :course_id
    permitted = params.permit attributes
    permitted.merge!({course: @course}) if not @course.nil?
    return permitted
  end


  def query_params
    params.permit(:name, :published)
  end

  def set_parent
    @course ||= Course.find params[:course_id]
  end

  # Prevent students from viewing unpublsihed projects
  # Or any projects belonging to an unpublished course
  def hide_unpublished
    params[:published] = true if @current_user.student?
    if @current_user.student? && !@course.published?
      raise ForbiddenError, error_messages[:forbidden_teacher_only]
    end
  end

  def base_index_query
    base = Project.where(course: @course)
    if not params[:due].nil?
      base = if params[:due] then base.due else base.not_due end
    end
    if params[:started]
      base = base.started
    end
    return base
  end
end
