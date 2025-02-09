class AuthsController < ApplicationController
  def create
    hmac_secret = ENV['JWT_SECRET'] || Rails.application.credentials.jwt_secret
    user = User.find_by(name: params[:name])

    if user && user.authenticate(params[:password])
      payload = { user_id: user.id, name: user.name }
      token = JWT.encode(payload, hmac_secret, 'HS256')
      render json: { token: token }
    else
      render json: { error: 'Invalid name or password' }, status: :unauthorized
    end
  end
end
