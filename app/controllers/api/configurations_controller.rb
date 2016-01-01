class Api::ConfigurationsController < ApplicationController
  def index
    render json: Rails.application.config.configurations
  end
end
