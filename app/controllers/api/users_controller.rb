class Api::UsersController < ApplicationController
  prepend_before_action :authenticate, except: [:create]
  before_action :no_cache, except: [:index, :show]
  after_filter :reload_resource, only: [:create]
  after_filter :send_verification, only: [:create, :resend_verify]


  # Requests a password reset
  def reset_password
    UserMailer.pass_reset_email(@user).deliver_later
    head :no_content
  end

  # Confirm password reset
  # Expects reset to be present as token field in query
  def confirm_reset
  end


  def resend_verify
    head :no_content
  end

  # Verifies user account
  # Expects token to be present as token field in query
  def verify

  end

  private

  def user_params
    attributes = model_attributes
    attributes.delete :password_digest
    attributes.delete :verified
    attributes.delete :id
    attributes.delete :student
    params.permit attributes << :password
  end

  def reload_resource
    @user.reload if @user.persisted?
  end

  def send_verification
    UserMailer.verification_email(@user).deliver_later if @user.persisted?
  end

  def user_authorized
    @current_user.id == @user.id
  end

end
