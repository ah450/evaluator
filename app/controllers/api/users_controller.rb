class Api::UsersController < ApplicationController
  prepend_before_action :authenticate, only: [:index, :show, :update, :destroy]
  after_filter :no_cache, except: [:index, :show]
  after_filter :reload_resource, only: [:create]
  after_filter :send_verification, only: [:create]


  # Requests a password reset
  def reset_password
    if @user.can_resend_reset?
      UserMailer.pass_reset_email(@user).deliver_later
      head :no_content
    else
      render json: {message: error_messages[:too_soon]}, status: 420
    end
  end

  # Confirm password reset
  # Expects reset to be present as token field in query
  def confirm_reset
    new_pass = params[:pass]
    token = params[:token]
    if @user.reset_password token, new_pass
      head :no_content
    else
      render json: { message: error_messages[:incorrect_reset_token] },
       status: :unprocessable_entity
    end
  end


  def resend_verify
    if !@user.verified?
      if @user.can_resend_verify?
        send_verification
        head :no_content
      else
        render json: {message: error_messages[:too_soon]}, status: 420
      end
    else
      render json: {message: error_messages[:already_verified]},
        status: :bad_request
    end
  end

  # Verifies user account
  # Expects token to be present as token field in query
  def verify
    token = params[:token]
    if @user.verify token
      head :no_content
    else
      render json: { message: error_messages[:incorrect_verification_token] },
        status: :unprocessable_entity
    end
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
