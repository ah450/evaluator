class Api::TeamGradesController < ApplicationController
  prepend_before_action :set_parent, except: [:show, :destroy]
  prepend_before_action :authenticate

  def latest
    render json: @current_user.team_grades.where(project: @project)
      .order(created_at: :desc).take
  end

  private

  def set_parent
    @project ||= Project.find params[:project_id]
  end
end
