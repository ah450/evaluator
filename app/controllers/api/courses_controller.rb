class Api::CoursesController < ApplicationController
  prepend_before_action :authorize_teacher, only: [:destroy, :update, :create]
  prepend_before_action :authenticate
  before_action :hide_unpublished, only: [:index]
  before_action :hide_unpublished_single, only: [:show]

  


  private

  def hide_unpublished
    params[:published] = true if @current_user.student?
  end

  def hide_unpublished_single
    if @current_user.student? && !get_resource.published?
      raise ForbiddenError, error_messages[:forbidden_teacher_only]
    end
  end

  def query_params
    params.permit(:name, :published)
  end

  def course_params
    attributes = model_attributes
    attributes.delete :id
    params.permit attributes
  end

  def authorize_teacher
    raise ForbiddenError, error_messages[:forbidden_teacher_only] unless
      @current_user.teacher?
  end
end
