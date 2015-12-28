class Api::UsersController < ApplicationController
  prepend_before_action :authenticate, except: [:create]
  private

  def user_params
    attributes = model_attributes
    attributes.delete :password_digest
    attributes.delete :verified
    attributes.delete :id
    attributes.delete :student
    params.permit attributes << :password
  end

  def user_authorized
    @current_user.id == get_resource.id
  end

end
