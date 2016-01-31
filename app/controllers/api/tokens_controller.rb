class Api::TokensController < ApplicationController
  skip_filter :authorize, :authenticate, only: [:create]
  
  def create
    user = User.find_by_email(token_params[:email].downcase)
    raise AuthenticationError if user.nil?
    raise AuthenticationError unless user.authenticate(token_params[:password])
    raise ForbiddenError, error_messages[:unverified_login] unless user.verified?
    render json: {
      token: user.token(token_params[:expiration]),
      user: user
    }, status: :created
  end

  private
  def token_params
    params.require(:token).permit([:email, :password, :expiration])
  end
end
