class Api::TeamGradesController < ApplicationController
  prepend_before_action :set_parent, except: [:show, :destroy]
  before_action :set_resource, only: [:show]
  before_action :authorize_student, only: [:latest]
  prepend_before_action :authenticate
  before_action :can_view?, only: [:show]

  def latest
    render json: @current_user.team_grades.where(project: @project)
      .order(created_at: :desc).take
  end

  private

  def set_parent
    @project ||= Project.find params[:project_id]
  end

  def can_view?
    unless @current_user.can_view? @team_grade
      raise ForbiddenError, error_messages[:forbidden]
    end
  end
end
