class Api::LoginsController < ApplicationController
  skip_filter :authorize, :authenticate, only: [:create]
  
  def create
    user = User.find_by_email(login_params[:email])
    raise AuthenticationError if user.nil?
    raise AuthenticationError unless user.authenticate(login_params[:password])
    raise ForbiddenError, error_messages[:unverified_login] unless user.verified?
    render json: {
      token: user.token(login_params[:expiration]),
      user: user
    }, status: :created
  end

  private

  def login_params
    params.require(:token).permit([:email, :password, :expiration])
  end

end
